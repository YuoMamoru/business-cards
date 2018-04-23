# frozen_string_literal: true

FactoryBot.define do
  factory :card do
    association :company
    name("0" * 31)
    kana_name("0" * 63)
  end
end
