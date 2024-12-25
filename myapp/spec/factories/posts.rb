FactoryBot.define do
  factory :post do
    title { "MyString" }
    body { "MyText" }
    author { nil }
    tags { "MyString" }
  end
end
