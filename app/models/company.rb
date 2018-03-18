# frozen_string_literal: true

class Company < ApplicationRecord
  enum category: { ltd: 0x00, llc: 0x01, foundation: 0x10, university: 0x20 }
  enum category_position: { non: 0, before: 1, after: 2 }
  image_field :logo_image
  has_many :cards

  validates :name, presence: true
  validates :short_name, presence: true
  validates :kana_name, presence: true
  validates :category, presence: true
  validates :category_position, presence: true

  def formal_name
    case category_position.intern
    when :before
      self.class.human_attribute_name(category, locale: :ja) + name
    when :after
      name + self.class.human_attribute_name(category, locale: :ja)
    else
      name
    end
  end

  def omit_name
    case category_position.intern
    when :before
      self.class.human_attribute_name("omit_#{category}", locale: :ja) + short_name
    when :after
      short_name + self.class.human_attribute_name("omit_#{category}", locale: :ja)
    else
      short_name
    end
  end
end
