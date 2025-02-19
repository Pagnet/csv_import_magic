require 'rails_helper'

RSpec.describe CsvImportMagic::ImportersController, type: :controller do
  routes { CsvImportMagic::Engine.routes }

  describe 'POST #create' do
    def do_action(format = :html)
      post :create, params: { 
        importer: { 
          attachment: attachment,
          importable_type: 'User',
          importable_id: create(:user).id,
          source: 'company' 
        } 
      }, format: format
    end

    context 'with valid params' do
      let(:attachment) { fixture_file_upload(Rails.root.join('../fixtures/companies.csv')) }

      it 'create a import for the company' do
        expect { do_action }.to change(Importer, :count).by(1)
      end

      context 'respond to html' do
        it 'redirect to edit' do
          do_action
          import = Importer.last
          expect(response).to redirect_to(edit_importer_path(import.id))
          expect(flash[:alert]).to eq('Por favor, informe em quais colunas podemos encontrar as informações que você deseja.')
        end
      end

      context 'respond to json' do
        it 'return the importer' do
          do_action(:json)
          import = Importer.last
          expect(response).to be_successful
          expect(JSON.parse(response.body)).to include('importer' => include('id' => import.id))
          expect(JSON.parse(response.body)).to include('columns' => include(['Ignorar esta coluna', 'ignore'], ['Nome', 'name'], ['Rua', 'street'], ['Numero', 'number'], ['Bairro', 'neighborhood'], ['Cidade', 'city'], ['Estado', 'state'], ['Pais', 'country']))
          expect(JSON.parse(response.body)).to include('data' => include(a_hash_including('bairro' => 'Joao de Barro', 'cidade ' => 'Birigui', 'estado ' => 'SP ', 'nome' => 'foo', 'numero' => '1', 'pais' => 'Brasil', 'rua' => 'R: Teste')))
        end
      end
    end

    context 'with invalid params' do
      let(:attachment) { nil }

      context 'respond to html' do
        it 'render to edit with error' do
          @request.env['HTTP_REFERER'] = 'http://example.com'
          do_action
          expect(response).to redirect_to('http://example.com')
          expect(flash[:error]).to eq('A validação falhou: Anexo CSV não pode ficar em branco')
        end
      end

      context 'respond to json' do
        it 'return the error' do
          do_action(:json)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include('error' => 'A validação falhou: Anexo CSV não pode ficar em branco')
        end
      end
    end
  end

  describe 'GET #show' do
    let(:importer) { create :importer }

    def do_action(format = :html)
      get :show, params: { id: importer.id }, format: format
    end

    context 'respond to html' do
      it 'return OK' do
        do_action
        is_expected.to respond_with(:success)
        is_expected.to render_template(:show)
        expect(assigns(:importer)).to eq(importer)
      end
    end

    context 'respond to json' do
      it 'return the importer' do
        do_action(:json)
        get :show, params: { id: importer.id }, format: :json
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to have_key('importer')
        expect(JSON.parse(response.body)).to have_key('attachment_error_url')
      end
    end
  end

  describe 'GET #edit' do
    let(:importer) { create :importer }

    def do_action(format = :html)
      get :edit, params: { id: importer.id }, format: format
    end

    context 'respond to html' do
      it 'return OK' do
        do_action
        is_expected.to respond_with(:success)
        is_expected.to render_template(:edit)
        expect(assigns(:importer)).to eq(importer)
        expect(controller.send(:import_file_csv).headers).to match_array(['bairro', 'cidade ', 'cod', 'estado ', 'nome', 'numero', 'pais', 'rua'])
      end
    end

    context 'respond to json' do
      it 'return the importer' do
        do_action(:json)
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to include('id' => importer.id)
      end
    end
  end

  describe 'PUT #update' do
    let(:importer) { create :importer, columns: [] }

    def do_action(columns, format = :html)
      put :update, params: { id: importer.id, importer: { columns: columns } }, format: format
    end

    context 'respond to html' do
      context 'with valid columns' do
        it 'update the importer columns list' do
          do_action(%w(neighborhood city cod state name number country street))
          expect(importer.reload.columns).to eq(%w(neighborhood city cod state name number country street))
        end

        it 'redirect back to employees index' do
          do_action(%w(neighborhood city cod state name number country street))
          expect(response).to redirect_to(importer_path(importer))
          expect(flash[:notice]).to eq('Arquivo enviado para processamento.')
        end

        it 'enqueue the Importer::EmployeesCSVWorker' do
          expect(CsvImportMagic::ImporterWorker).to receive(:perform_async).with(importer_id: importer.id, resources: nil)
          do_action(%w(neighborhood city cod state name number country street))
        end
      end

      context 'with invalid columns' do
        it 'render the edit screen' do
          do_action(%w(neighborhood city cod state name name number country street))
          is_expected.to respond_with(:success)
          is_expected.to render_template(:edit)
          expect(assigns(:importer)).to eq(importer)
          expect(flash[:alert]).to eq('Colunas Nome deve ser única')
        end
      end
    end

    context 'respond to json' do
      context 'with valid columns' do
        it 'return the importer' do
          do_action(%w(neighborhood city cod state name number country street), :json)
          expect(response).to be_successful
          expect(JSON.parse(response.body)).to include('id' => importer.id)
        end
      end

      context 'with invalid columns' do
        it 'return the error' do
          do_action(%w(neighborhood city cod state name name number country street), :json)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include('error' => 'Colunas Nome deve ser única')
        end
      end
    end
  end
end
