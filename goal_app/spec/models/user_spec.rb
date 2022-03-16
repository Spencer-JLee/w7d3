require 'rails_helper'

RSpec.describe User, type: :model do
  it {should validate_presence_of(:username) }
  it {should validate_presence_of(:password_digest) }
  it {should validate_presence_of(:session_token) }
  it {should validate_length_of(:password).is_at_least(6) }
  # it {should validate_uniqueness_of(:username)}
  it {should have_many(:goals)}

  describe "find users by credentials" do
    context "with a valid username and password" do
      it "returns the user" do
        sally = FactoryBot.create(:user)
        user = User.find_by_credentials(sally.username, sally.password)
        expect(sally.username).to eq(user.username)
        expect(sally.password).to eq(user.password)
      end
    end

    context "with an invalid username and password" do
      it "should return nil" do
        bob = User.create("Bob", "asd")
        user = User.find_by_credentials(bob.username, bob.password)
        expect(user).to be_nil
      end
    end
  end

  describe 'uniqueness' do
    before (:each) do
      FactoryBot.create(:user)
    end
    it {should validate_uniqueness_of(:username)}
    it {should validate_uniqueness_of(:session_token)}
  end

  describe 'is_password?' do
    let!(:user) { create(:user)}

    context "with a valid password" do
      it "should return true" do
        expect(user.is_password?("password").to be true)
      end
    end

    context "with an invalid password" do
      it "should return false" do
        expect(user.is_password?("").to be false)
      end
    end
  end

  describe "password encryption" do
    it 'does not save the password to the database' do
      harry = FactoryBot.create(:user) 

      user = User.find_by(username: harry.username)
      expect(user.password).not_to eq('password')
    end

    it 'encrypts password using BCrypt' do
      expect(BCrypt::Password).to receive(:create).with('lsdkf')
      FactoryBot.build(:user, password: 'lsdkf')
    end
  end

  subject{User.create!(username: 'Sean', password: 'spencer') }

  describe "session token" do

    it "assigns a session token if one is not given" do
      expect(subject.session_token).not_to be_nil
    end

    it "resets a session token for a user" do
      old_session_token = subject.session_token
      new_session_token = subject.reset_session_token!
      expect(old_session_token).not_to eq(new_session_token)
    end
  end

end