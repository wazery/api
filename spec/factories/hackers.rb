# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :hacker do
    sequence(:email) { |i| "hacker.#{i}@hackhub.io" }
    sign_in_count 1
    confirmed_at '2014-06-06 19:29:36'
    current_sign_in_at '2014-06-08 19:29:36'
    last_sign_in_at '2014-06-07 19:29:36'
    current_sign_in_ip
    last_sign_in_ip
    name 'Islam Wazery'
    github_token 'GKRVYN-xtMIfNMZdY-Z61Q'
    sequence(:created_at) { |i| i.minutes.from_now.beginning_of_minute }
  end
end
