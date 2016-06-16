require 'rails_helper'
require_relative '../support/auth_helper.rb'

RSpec.describe ItemsController, type: :controller do
  before(:each) do
    @admin = create :admin
  end

  let(:item2) {build :item}
  let!(:item) {create :item}

  describe "GET #index" do
    it "renders the index page" do
      get :index
      expect(response).to have_rendered('items/index')
    end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "renders the index page" do
      get :new, {}, { user_id: @admin.id  }
      expect(response).to have_rendered('items/new')
    end

    it 'responds with a status of 200' do
      get :new, {}, { user_id: @admin.id  }
      expect(response.status).to eq(200)
    end

    it 'assigns the items instance variable' do
      get :new, {}, { user_id: @admin.id  }
      expect(assigns(:item)).to be_a_new(Item)
    end
  end

  describe "POST #create" do
    let(:params) {{"item"=>{"name"=>"Danny", "price"=>20, "quantity"=>2, "description"=>"What?"}}}
    it 'increments items in the database by 1' do
      expect{
        post :create, params, { user_id: @admin.id }
      }.to change{Item.count}.by(1)
    end

    it 'responds with a status of 302' do
      post :create, params, { user_id: @admin.id }
      expect(response.status).to eq(302)
    end
  end

  describe "GET #edit" do

    it "renders the edit page" do
      get :edit, { id: item.id}, {user_id: @admin.id}
      expect(response).to render_template('items/edit')
    end

  end

  describe "GET #show" do
    it "renders the show page" do
      get :show, id: item.id
      expect(response).to render_template('items/show')
    end
  end

  describe "PATCH #update" do
    let(:params) {{"item"=>{name: item.name, price: 20, description: "Yes"}, "id"=>item.id}}
    context '"description"=>"Yes"on valid params' do
      it 'responds with a status of 302' do
        patch :update, params, { user_id: @admin.id  }
        expect(response.status).to eq(302)
      end
      it 'updates an item in the database' do
        patch :update, params, { user_id: @admin.id  }
        expect(item.reload.price).to eq(20)
      end
    end
    context 'on invalid params' do
      let(:params) {{item: {name: ''}, id: item.id}}
      it 'does not change an item in the database' do
        patch :update, params
        expect(item.name).to_not eq('')
      end
    end
  end

  describe "DELETE #destroy" do
    it 'responds with a status of 302' do
      delete :destroy, {id: item.id}, { user_id: @admin.id}
      expect(response.status).to eq(302)
    end
    it 'decrements the items in the database by 1' do
      expect{
        delete :destroy, {id: item.id}, { user_id: @admin.id}
      }.to change{Item.count}.by(-1)
    end
  end

end
