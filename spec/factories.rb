include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user do
    name 'test'
    email 'foo@bar.com'
    password '123456'
    password_confirmation '123456'
    avatar { fixture_file_upload(Rails.root.join('spec/support/ruby.png'), 'image/png') }
  end
end