require 'rails_helper'

describe "Post pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { valid_signin user }

  describe "post creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a post" do
        expect { click_button "Post" }.not_to change(Post, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'post_content', with: "Lorem ipsum" }
      it "should create a post" do
        expect { click_button "Post" }.to change(Post, :count).by(1)
        end
      end
    end

  describe "post destruction" do
    let!(:post) { FactoryGirl.create(:post, user: user) }
    before {  visit root_path }

    describe "as  correct user", js:true do
      it { should have_link "delete" }
      it "should destroy post" do
        expect {click_link "delete"}.to change(Post, :count).by(-1)
      end
    end
  end

  describe "post editing", js: true  do
    let!(:post) { FactoryGirl.create(:post, user: user) }
    before { visit edit_post_path(post) }

    describe "home page as correct user" do
      before { visit root_path }
      it { should have_link "edit" }

      describe "click edit_link" do
        before { click_link 'edit' }
        it { should have_current_path(edit_post_path(post)) }

      end
    end

    describe "with valid content" do
      let(:valid_content) { "yo "*10 }
      before { make_post_with valid_content }

      it "should update post" do
        expect(post.reload.content).to eq valid_content
      end
    end

    describe "with empty content" do
      let(:empty_content) { '' }
      before { make_post_with empty_content }

      it { should have_error_message "error" }
      it "should not update post" do
        expect(post.reload.content).not_to be_empty
      end
    end
  end
end


