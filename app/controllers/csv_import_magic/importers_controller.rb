class CsvImportMagic::ImportersController < ActionController::Base
  helper_method :import_file_csv
  layout 'application'

  def create
    @importer = Importer.new(importer_params)

    if @importer.save! && import_file_csv
      redirect_to edit_importer_path(@importer), alert: 'Por favor, informe em quais colunas podemos encontrar as informações que você deseja.'
    end
  rescue ActiveRecord::RecordInvalid, CSV::MalformedCSVError => e
    redirect_to CsvImportMagic.after_create_redirect_with_error, flash: { error: e.message }
  end

  def edit
    @importer = ::Importer.find(params[:id])
  end

  def update
    @importer = ::Importer.find(params[:id])

    if @importer.update(csv_importer_magic_update_params)
      CsvImportMagic::ImporterWorker.perform_async(@importer.id)
      redirect_to CsvImportMagic.after_update_redirect_with_success, flash: { notice: 'Arquivo enviado para processamento.' }
    else
      errors = @importer.errors.full_messages.to_sentence
      flash[:alert] = errors.present? ? errors : 'Não foi possível enviar o arquivo para processamento, por favor tente movamente.'
      render :edit
    end
  end

  private
  def import_file_csv
    @csv ||= begin
      content = open(@importer.attachment.path).read.force_encoding('UTF-8')
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