# Create a sample user.
User.create!(name: 'KC Sheng',
             email: 'kacysheng@mail.com',
             password: '123456',
             password_confirmation: '123456',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name: 'Example User',
             email: 'example@mail.org',
             password: 'foobar',
             password_confirmation: 'foobar',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# Generate additional users.
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@mail.org"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# Microposts
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users = User.all
user = User.first
following = users[2..50]
followers = users[3..40]
following.each { |other_user| user.follow(other_user) }
followers.each { |other_user| other_user.follow(user) }