User.create!(name: "admin",
    email: "admin@suntour.org",
    phone_number: "0123456789",
    password: "admin1234",
    password_confirmation: "admin1234",
    role: 2)

User.create!(name: "test",
    email: "test@suntour.org",
    phone_number: "0987654321",
    password: "test1234",
    password_confirmation: "test1234",
    role: 1)

30.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(name:  name,
      email: email,
      password:              password,
      password_confirmation: password)
end