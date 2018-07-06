require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "Signup page" do
    before {visit signup_path}
    let(:submit) { 'Create my account' }

    it { should have_content('Sign up') }
    it { should have_title('Sign up') }

    describe "with invalid information" do
      it "should not create user" do
        expect{ click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title "Sign up" }
        it { should have_content "error" }
      end
    end

    describe "with valid information" do
      before do
          fill_in 'Name',         with: 'Petro'
          fill_in 'Email',        with: 'foo@bar.com'
          fill_in 'Password',     with: '123456'
          fill_in 'Confirmation', with: '123456'
      end
      it "should create new user" do
        expect{ click_button submit }.to change(User, :count).by(1)
      end
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'foo@bar.com') }

        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end

    end
  end

  describe "profile page" do
    before { visit user_path(user) }
    let(:user) { FactoryGirl.create(:user) }

    it {should have_content(user.name) }
    it { should have_title(user.name) }
  end
end