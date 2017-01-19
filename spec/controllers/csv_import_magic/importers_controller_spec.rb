require 'rails_helper'

RSpec.describe CsvImportMagic::ImportersController, type: :controller do
  routes { CsvImportMagic::Engine.routes }

  describe 'POST #create' do
    def do_action
      post :create, importer: { attachment: attachment, importable_type: 'User', importable_id: create(:user).id, source: 'company' }
    end

    context 'with valid params' do
      let(:attachment) { fixture_file_upload(Rails.root.join('../fixtures/companies.csv')) }

      it 'create a import for the company' do
        expect { do_action }.to change(Importer, :count).by(1)
      end

      it 'redirect to edit' do
        do_action
        import = Importer.last
        expect(response).to redirect_to(edit_importer_path(import.id))
        expect(flash[:alert]).to eq('Por favor, informe em quais colunas podemos encontrar as informações que você deseja.')
      end
    end

    context 'with invalid params' do
      let(:attachment) { nil }

      it 'render to edit with error' do
        @request.env['HTTP_REFERER'] = 'http://example.com'
        do_action
        expect(response).to redirect_to('http://example.com')
        expect(flash[:error]).to eq('A validação falhou: Anexo CSV não pode ficar em branco')
      end
    end
  end

  describe 'GET #show' do
    let(:importer) { create :importer }

    def do_action
      get :show, id: importer.id
    end

    before { do_action }

    it 'return OK' do
      is_expected.to respond_with(:success)
      is_expected.to render_template(:show)
      expect(assigns(:importer)).to eq(importer)
    end
  end

  describe 'GET #edit' do
    let(:importer) { create :importer }

    def do_action
      get :edit, id: importer.id
    end

    before { do_action }

    it 'return OK' do
      is_expected.to respond_with(:success)
      is_expected.to render_template(:edit)
      expect(assigns(:importer)).to eq(importer)
      expect(controller.send(:import_file_csv).headers).to match_array(['bairro', 'cidade ', 'cod', 'estado ', 'nome', 'numero', 'pais', 'rua'])
    end
  end

  describe 'PUT #update' do
    let(:importer) { create :importer }

    def do_action(columns)
      put :update, id: importer.id, importer: { columns: columns }
    end

    context 'with valid columns' do
      it 'update the importer columns list' do
        do_action(%w(bairro cidade cod estado nome numero pais rua))
        expect(importer.reload.columns).to eq(%w(bairro cidade cod estado nome numero pais rua))
      end

      it 'redirect back to employees index' do
        do_action(%w(bairro cidade cod estado nome numero pais rua))
        expect(response).to redirect_to(importer_path(importer))
        expect(flash[:notice]).to eq('Arquivo enviado para processamento.')
      end

      it 'enqueue the Importer::EmployeesCSVWorker' do
        expect(CsvImportMagic::ImporterWorker).to receive(:perform_async).with(importer.id)
        do_action(%w(bairro cidade cod estado nome numero pais rua))
      end
    end

    context 'with invalid columns' do
      it 'render the edit screen' do
        do_action(%w(bairro cidade cod estado nome nome numero pais rua))
        is_expected.to respond_with(:success)
        is_expected.to render_template(:edit)
        expect(assigns(:importer)).to eq(importer)
        expect(flash[:alert]).to eq('Colunas devem ser únicas')
      end
    end
  end
end
