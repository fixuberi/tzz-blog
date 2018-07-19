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

  describe "post editing"  do
    let!(:post) { FactoryGirl.create(:post, user: user) }
    before { visit root_path }

    describe "as correct user" do
      it { should have_link "edit" }

      describe  "click 'edit' " do
        subject(:click_edit) { click_link "edit" }
        #before { click_link "edit" }
        #it { expect(click_edit).to redirect_to(edit_post_path(post)) }
        it "should redirect to post_edit_page" do
          expect(click_edit).to redirect_to :controller => :posts_controller,
                                            :action => :edit,
                                            :id => post.id
        end

      end

      describe "with valid content" do
        let(:valid_content) { "yo "*10 }
        before do
          fill_in 'post_content', with: valid_content
          click_button "Post"
        end

        it "should update post" do
          expect(Post.find(post.id).content).to eq valid_content
        end
      end

      describe "with empty content" do
        before do
          fill_in 'post_content', with: ''
          click_button "Post"
        end
        it { should have_error_message "error" }
        it "should not update" do
          expect(Post.find(post.id).content).not_to be_empty
        end
      end
    end
  end
end


