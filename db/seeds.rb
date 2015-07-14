User.create!(name:  "Simeon Muyiwa",
             email: "muyiwa100@yahoo.com",
             password:              "busayo20",
             password_confirmation: "busayo20",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
User.create!(name:  name,
             email: email,
             password:              password,
             password_confirmation: password,
              activated: true,
             activated_at: Time.zone.now)
 end