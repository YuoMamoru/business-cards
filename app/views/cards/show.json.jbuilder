# frozen_string_literal: true

json.key_format! camelize: :lower
json.extract! @card, :id, :name, :kana_name, :department, :position, :postcode, :address, :building, :tel, :cellular_phone, :fax, :mail, :qualification, :note, :created_at, :updated_at
json.company do
  json.partial! "companies/company", company: @card.company
end
if @card.front_image.nil?
  json.front_image nil
else
  json.front_image do
    json.base64_data @card.front_image.base64_data
    json.content_type @card.front_image.content_type
    json.width @card.front_image.width
    json.height @card.front_image.height
  end
end
if @card.back_image.nil?
  json.back_image nil
else
  json.back_image do
    json.base64_data @card.back_image.base64_data
    json.content_type @card.back_image.content_type
    json.width @card.back_image.width
    json.height @card.back_image.height
  end
end
json.editPath edit_card_path(@card)
json.url card_url(@card, format: :json)
