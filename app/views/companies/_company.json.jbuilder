# frozen_string_literal: true

json.extract! company, :id, :name, :short_name, :kana_name, :en_name, :category, :category_position, :note, :web_site, :created_at, :updated_at
if company.logo_image.nil?
  json.logo_image nil
else
  json.logo_image {
    json.base64_data company.logo_image.base64_data
    json.content_type company.logo_image.content_type
  }
end
json.url company_url(company, format: :json)
