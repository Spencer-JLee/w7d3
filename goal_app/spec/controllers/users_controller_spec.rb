require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  subject (:randy) {User.create!(username: 'randy', password: "password")}

  describe "GET #new" do
    it "renders the new users template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "with invalid params" do
      it "validates the presence of the user's username and passwords and returns the user to the sign up page" do
        post :create, params: {user: {username: "Adam", password: ""}}
        expect(response).to render_template("new")
        expect(flash[:errors]).to eq(["Password is too short (minimum is 6 characters)"])
      end

      it "validates the password is at least 6 characters long and returns the user to sign up page" do
         post :create, params: {user: {username: "Adam", password: "asdf"}}
         expect(response).to render_template("new")
         expect(flash[:errors]).to eq(["Password is too short (minimum is 6 characters)"])
      end
    end

    context "with valid params" do
      it "redirects user to users show page on success" do
        post :create, params: {user: {username: "Adam", password: "password"}}
        user = User.find_by_username("Adam")
        expect(response).to redirect_to(user_url(user))
      end

      it "logins the user" do
        post :create, params: {user: {username: "Adam", password: "password"}}
        user = User.find_by_username("Adam")
        expect(session[:session_token]).to eq(user.session_token)
      end
    end
  end

  describe "GET #show" do
    context "when logged in" do
      before do
        allow(controller).to receive(:current_user){ randy}
      end

      it "renders the show page of the specified user" do
        get :show, params: {id: randy.id}
        fetched_user = controller.instance_variable_get(:@user)
        expect(fetched_user).to eq(User.find(randy.id))
        expect(response).to render_template(:show)
      end
    end

    context "when logged out" do 
      before do
        allow(controller).to receive(:current_user){ nil}
      end

      it "redirects to the login page" do
        get :show, params: {id: randy.id}
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "GET #index" do
    context "when logged in" do
      before do
        allow(controller).to receive(:current_user) {randy}
      end
      it "renders the index page of all of the users" do
        get :index
        fetched_users = controller.instance_variable_get(:@users)
        expect(fetched_users).to eq(User.all)
        expect(response).to render_template(:index)
      end
    end

    context "when logged out" do
      before do
        allow(controller).to receive(:current_user){ nil}
      end

      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

end