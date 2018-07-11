# frozen_string_literal: true

json.cards do
  json.array! @cards, :id, :company_id, :name, :kana_name, :department, :position, :postcode, :address, :tel, :cellular_phone, :fax, :mail, :front_image, :back_image, :qualification, :note, :created_at, :updated_at
end
json.companies do
  @companies.each do |company|
    json.set! company.id do
      json.extract! company, :id, :formal_name, :omit_name, :short_name
      if company.logo_image
        json.logo_image do
          json.content_type company.logo_image.content_type
          json.base64_data company.logo_image.base64_data
          json.width company.logo_image.width
          json.height company.logo_image.height
        end
      else
        json.logo_image nil
      end
    end
  end
end
