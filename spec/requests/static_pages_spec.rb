require 'spec_helper'

describe "Statc pages" do
  subject { page }

 describe "home" do
   before { visit root_path }

   it { should have_title "Tzz-blog" }
   it { should have_content "Tzz-blog" }

   describe "for signed-in users" do

   end
 end
end