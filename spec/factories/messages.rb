FactoryBot.define do
  factory :message do
    body {Faker::Lorem.sentence}
    # 「Rails.root」：/User/~~/アプリケーション
    image {File.open("#{Rails.root}/public/images/test_image.jpg")}
    user
    group
  end
end