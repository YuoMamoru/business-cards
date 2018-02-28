# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :company

  validates :name, length: { maximum: 31 }, presence: true
  validates :kana_name, length: { maximum: 63 }, presence: true
  validates :postcode, format: { with: /\A(|\d{3}\-\d{4})\z/ }
  validates :address, length: { maximum: 255 }
  validates :tel, format: { with: /\A(|0[\d\-]{11,14})\z/ }
  validates :fax, format: { with: /\A(|0[\d\-]{11,14})\z/ }
  validates :mail, format: { with: /\A(|[\w+\-.]+@[a-z\d\-.]+\.[a-z]+)\z/ }, length: { maximum: 255 }
  validates :qualification, length: { maximum: 255 }
  validates :note, length: { maximum: 255 }
end
