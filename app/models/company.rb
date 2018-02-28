# frozen_string_literal: true

class Company < ApplicationRecord
  enum category: { ltd: 0x00, llc: 0x01, foundation: 0x10, university: 0x20 }
  enum category_position: { nonen: 0, before: 1, after: 2 }
  image_field :logo_image
  has_many :cards

  validates :name, presence: true
  validates :short_name, presence: true
  validates :kana_name, presence: true
  validates :category, presence: true
  validates :category_position, presence: true
end
