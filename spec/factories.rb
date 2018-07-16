include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Uzver#{n}" }
    sequence(:email) { |n| "uzver#{n}@gmail.com"}
    password '123456'
    password_confirmation '123456'
    avatar { fixture_file_upload(Rails.root.join('spec/support/ruby.png'), 'image/png') }
  end

  factory :post do
    content "yo bitch!"
    user
  end
end