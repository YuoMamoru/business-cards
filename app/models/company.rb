# frozen_string_literal: true

class Company < ApplicationRecord
  enum category: { ltd: 0x00, llc: 0x01, foundation: 0x10, university: 0x20 }
  enum category_position: { nonen: 0, before: 1, after: 2 }
  has_many :cards

  validates :name, presence: true
  validates :short_name, presence: true
  validates :kana_name, presence: true
  validates :category, presence: true
  validates :category_position, presence: true

  def logo_image
    @logo_image ||= logo_image_data && Image.new(logo_image_data)
  end

  def logo_image=(image)
    self.logo_image_data = image.data
  end

  def logo_image_data=(data)
    case data
    when ActionDispatch::Http::UploadedFile
      data.open
      begin
        @logo_image = Image.new(data.read)
      ensure
        data.close
      end
    when IO
      @logo_image = Image.new(data.read)
    else
      @logo_image = Image.new(data)
    end
    super(logo_image.data)
  end
end
