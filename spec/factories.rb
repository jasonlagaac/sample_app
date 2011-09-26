Factory.define :user do |user|
  user.name                   "Darth Vader"
  user.email                  "darth.vader@galacticempire.net"
  user.password               "noooooo"
  user.password_confirmation  "noooooo"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
