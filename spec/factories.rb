FactoryGirl.define do
  factory :user do
    name 'test'
    email 'foo@bar.com'
    password '123456'
    password_confirmation '123456'
  end
end