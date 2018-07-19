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
      it "should delete post" do
        expect {click_link "delete"}.to change(Post, :count).by(-1)
      end
    end
  end

  describe "post editing" do
    let!(:post) { FactoryGirl.create(:post, user: user) }
    before { visit root_path }

    describe "as correct user" do
      it { should have_link "edit" }
      it "should redirect to edit post page" do
        expect {click_link "edit"}.to redirect_to(edit_post_path(post))
      end
      describe "with valid content" do
        let(:valid_content) { "a"*280 }
        before do
          fill_in 'post_content', with: valid_content
          click_button "Edit post"
        end

        it "should update post" do
          expect(Post.find(post.id).content).to eq valid_content
        end
      end

      describe "with empty content" do
        before do
          fill_in 'post_content', with: ''
          click_button "Edit post"
        end
        it { should have_selector }
      end
    end
  end
end


