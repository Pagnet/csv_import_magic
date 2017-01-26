module CsvImportMagic
  class ImportersController < CsvImportMagic::BaseController
    helper_method :import_file_csv
    layout 'csv_import_magic'

    def show
      @importer = ::Importer.find(params[:id])
    end

    def create
      @importer = ::Importer.new(importer_params)

      if @importer.save! && import_file_csv
        redirect_to edit_importer_path(@importer), alert: t('csv_import_magic.importers_controller.create.alert')
      end
    rescue ActiveRecord::RecordInvalid, CSV::MalformedCSVError => e
      redirect_to request.referrer, flash: { error: e.message }
    end

    def edit
      @importer = ::Importer.find(params[:id])
    end

    def update
      @importer = ::Importer.find(params[:id])

      if @importer.update(csv_importer_magic_update_params)
        CsvImportMagic::ImporterWorker.perform_async(importer_id: @importer.id, resources: resources)
        redirect_to importer_path(@importer), flash: { notice: t('csv_import_magic.importers_controller.update.notice') }
      else
        errors = @importer.errors.full_messages.to_sentence
        flash[:alert] = errors.present? ? errors : t('csv_import_magic.importers_controller.update.alert')
        render :edit
      end
    end

    private

    def resources
      method_name = "#{@importer.source}_resources"
      respond_to?(method_name) ? send(method_name) : nil
    end

    def import_file_csv
      @csv ||= begin
        content = Paperclip.io_adapters.for(@importer.attachment).read.force_encoding('UTF-8')
        content = content.encode('UTF-8', content.encoding, invalid: :replace, undef: :replace)
        ::CSV.parse(content, headers: true, col_sep: column_separator)
      end
    end

    def column_separator
      ::CsvImportMagic::Importer.new(@importer.id).column_separator
    end

    def importer_params
      params.require(:importer).permit!
    end

    def csv_importer_magic_update_params
      params.require(:importer).permit(columns: [])
    end
  end
end
