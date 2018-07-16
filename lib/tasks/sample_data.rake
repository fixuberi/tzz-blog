namespace :db do
  desc "fill db with the sample data"
  task populate: :environment do
    50.times  do |n|
      name = Faker::Name.name
      email = "test#{n}@gmail.com"
      password = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all.limit(6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.posts.create!(content:content) }
    end
  end
end
