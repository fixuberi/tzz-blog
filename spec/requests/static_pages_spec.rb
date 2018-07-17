require 'spec_helper'

describe "Statc pages" do
  subject { page }

 describe "home" do
   before { visit root_path }

   it { should have_title "Tzz-blog" }
   it { should have_content "Tzz-blog" }

   describe "for signed-in users" do
     let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:post, user: user, content: "Lorem")
        FactoryGirl.create(:post, user: user, content: "Dolor")
        valid_signin user
        visit root_path
      end

     it "should render the users feed" do
       user.feed.each do |item|
         expect(page).to have_selector("li##{item.id}", text: item.content)
       end
     end
   end
 end
end