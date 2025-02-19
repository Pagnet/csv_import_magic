module CsvImportMagic
  class ImportersController < CsvImportMagic::BaseController
    helper_method :import_file_csv
    layout 'csv_import_magic'
    respond_to :html, :json

    def show
      @importer = ::Importer.find(params[:id])

      respond_with do |format|
        format.html
        format.json do
          render json: {
            importer: @importer,
            attachment_error_url: @importer&.attachment_error&.url,
          } 
        end
      end
    end

    def create
      @importer = ::Importer.new(importer_params)

      if @importer.save! && import_file_csv
        respond_with do |format|
          format.html { redirect_to edit_importer_path(@importer), alert: t('csv_import_magic.importers_controller.create.alert') }
          format.json do 
            render json: {
              columns: @importer.importable_columns(@importer.parser).map { |column| [@importer.human_attribute_name(column), column] }.unshift([t('csv_import_magic.views.importers.edit.ignore_column_label'), :ignore]),
              data: import_file_csv.map(&:to_hash),
              importer: @importer
            }
          end
        end
      end
    rescue ActiveRecord::RecordInvalid, CSV::MalformedCSVError => e
      respond_with do |format|
        format.html { redirect_back fallback_location: '/', flash: { error: e.message } }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    end

    def edit
      @importer = ::Importer.find(params[:id])

      respond_with do |format|
        format.html
        format.json { render json: @importer }
      end
    rescue ActiveRecord::RecordNotFound
      respond_with do |format|
        format.html
        format.json { render json: { error: 'importer not found' }, status: :unprocessable_entity }
      end
    end

    def update
      @importer = ::Importer.find(params[:id])

      if @importer.update(csv_importer_magic_update_params)
        CsvImportMagic::ImporterWorker.perform_async(importer_id: @importer.id, resources: resources)

        respond_with do |format|
          format.html { redirect_to importer_path(@importer), flash: { notice: t('csv_import_magic.importers_controller.update.notice') } }
          format.json { render json: @importer }
        end
      else
        errors = @importer.errors.full_messages.to_sentence
        
        respond_with do |format|
          format.html do 
            flash[:alert] = errors.present? ? errors : t('csv_import_magic.importers_controller.update.alert')
            render :edit
          end
          format.json { render json: { error: errors.present? ? errors : t('csv_import_magic.importers_controller.update.alert') }, status: :unprocessable_entity }
        end
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

        if !content.nil?
          content = content.gsub(/\r/, "\n")
          content = content.gsub(/\n\n/, "\n")
        end

        ::CSV.parse(content, headers: true, col_sep: column_separator)
      end
    end

    def column_separator
      ::CsvImportMagic::Importer.new(@importer.id).column_separator
    end

    def importer_params
      params.require(:importer).permit(:source, :attachment, :importable_type, :importable_id, :parser)
    end

    def csv_importer_magic_update_params
      params.require(:importer).permit(columns: [])
    end
  end
end
