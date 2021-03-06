require 'spec_helper'


describe User do
 before do
   @user = User.new(name: "petro", email: "foo@bar.com",
                    password: "foobar", password_confirmation: "foobar")
 end
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:avatar) }
  it { should respond_to(:posts)}
  it { should respond_to(:feed) }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  describe "when EMAIL is not present" do
    before { @user.email = ' ' }
    it { should_not be_valid }
  end
  describe "when name is too long" do
    before { @user.name = 'a'*51 }
    it { should_not be_valid}
  end

  describe "when email format is invalid" do
    it 'should be invalid' do
      addresses = %W[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  describe "when email format is valid" do
    it 'should be valid' do
      addresses = %W[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_addess|
        @user.email = valid_addess
        expect(@user).to be_valid
      end
    end
  end

 describe "email address with mixed keys" do
   let(:mixed_keys_email) { 'FoB@Ar.CoM' }

   it "should be save in low-case" do
    @user.email = mixed_keys_email
    @user.save
     expect(@user.reload.email).to eq mixed_keys_email.downcase
   end
 end

  describe "when email address is already taken" do
    before do
      user_witn_same_email = @user.dup
      user_witn_same_email.email.upcase!
      user_witn_same_email.save
    end
    it { should_not  be_valid }
  end


 describe "with password that's too short" do
   before { @user.password = @user.password_confirmation = 'a'*5 }
   it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before do
      @user.save
    end
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it 'should be equal found user' do
        expect(@user).to eq(found_user.authenticate(@user.password))
      end
    end
    describe "with INvalid password" do
      let(:user_for_invalid_password) { found_user.authenticate('invalid pass') }
      it { should_not eq user_for_invalid_password }
        specify { expect(user_for_invalid_password).to be false }
    end
  end

  describe "remeber_token" do
    before { @user.save }
    it { expect(@user.remember_token ).not_to be_blank }
  end

 describe "post associations" do
   before { @user.save }
   let!(:older_post) { FactoryGirl.create(:post, user: @user, created_at: 1.day.ago) }
   let!(:newer_post) { FactoryGirl.create(:post, user: @user, created_at: 1.hour.ago) }

   it "should have right posts in right order" do
     expect(@user.posts.to_a).to eq [newer_post, older_post]
   end

   it "should destroy associated posts" do
     posts = @user.posts.to_a
     @user.destroy
     expect(posts).not_to  be_empty
     posts.each do |post|
       expect(Post.where(id: post.id)).to be_empty
     end
   end

   describe "by status" do
     let(:unfollowed_post) { FactoryGirl.create(:post, user: FactoryGirl.create(:user)) }
     it "should include user's posts" do
       expect(subject.feed).to include older_post
       expect(subject.feed).to include newer_post
     end
     it "should not include unfollowed posts" do
     expect(subject.feed).not_to include unfollowed_post
     end
   end
 end
end

