# frozen_string_literal: true

json.key_format! camelize: :lower
json.extract! company, :id, :formal_name, :omit_name, :name, :short_name, :kana_name, :en_name, :category, :category_position, :note, :web_site, :color, :created_at, :updated_at
if company.logo_image.nil?
  json.logo_image nil
else
  json.logo_image do
    json.base64_data company.logo_image.base64_data
    json.content_type company.logo_image.content_type
    json.width company.logo_image.width
    json.height company.logo_image.height
  end
end
json.editPath edit_company_path(company)
json.url company_url(company, format: :json)
