# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    name "Company Name"
    short_name "Comp"
    kana_name "comp name"
    category :ltd
    category_position :after
  end
end
