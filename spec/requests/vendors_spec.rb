require 'rails_helper'

RSpec.describe VendorsController, type: :controller do
  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      vendor = FactoryBot.create(:vendor)
      get :show, params: { id: vendor.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      vendor = FactoryBot.create(:vendor)
      get :edit, params: { id: vendor.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'GET #review' do
    it 'renders the review template' do
      vendor = FactoryBot.create(:vendor)
      get :review, params: { id: vendor.id }
      expect(response).to render_template(:review)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new vendor' do
        expect do
          post :create, params: { vendor: { name: 'New Vendor' } }
        end.to change(Vendor, :count).by(1)
      end

      it 'redirects to the created vendor' do
        post :create, params: { vendor: { name: 'New Vendor' } }
        expect(response).to redirect_to(Vendor.last)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new vendor' do
        expect do
          post :create, params: { vendor: { name: '' } }
        end.to_not change(Vendor, :count)
      end

      it 'renders the new template' do
        post :create, params: { vendor: { name: '' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    let(:vendor) { FactoryBot.create(:vendor) }

    context 'with valid parameters' do
      it 'updates the vendor' do
        patch :update, params: { id: vendor.id, vendor: { name: 'New Name' } }
        expect(vendor.reload.name).to eq('New Name')
      end

      it 'redirects to the updated vendor' do
        patch :update, params: { id: vendor.id, vendor: { name: 'New Name' } }
        expect(response).to redirect_to(vendor)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the vendor' do
        patch :update, params: { id: vendor.id, vendor: { name: '' } }
        expect(vendor.reload.name).to_not eq('')
      end

      it 'renders the edit template' do
        patch :update, params: { id: vendor.id, vendor: { name: '' } }
        expect(response).to render_template(:edit)
      end
    end
  end
end
