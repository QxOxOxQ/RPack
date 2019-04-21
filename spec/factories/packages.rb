# frozen_string_literal: true

FactoryBot.define do
  factory :package do
    description { "MyString" }
    title { "MyString" }
    authors { "MyString" }
    version { "MyString" }
    maintainers { "MyString" }
    license { "MyString" }
    publication_date { "2019-04-21" }
  end
end
