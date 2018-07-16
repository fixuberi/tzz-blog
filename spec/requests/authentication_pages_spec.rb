require 'rails_helper'


RSpec.describe "Authentication"  do
  subject { page }

  describe "sign in page" do
    before  { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title("Sign in") }
      it { should have_error_message("Invalid") }

      describe "afrter visiting another page" do
        before { click_link "Home" }
        it { should_not have_error_message }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href:signin_path)}

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { pending "cant see link";  should have_link("Sign in", href:signin_path) }
      end
    end
  end

  describe "authorization", type: :request do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Posts controller" do

        describe "submitting to the create action" do
          before { post posts_path }
          specify { expect(response).to redirect_to(signin_path) }
        end
        describe "submiting to the destroy action" do
          before { delete post_path(FactoryGirl.create(:post)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end
  end
end