# frozen_string_literal: true

json.extract! company, :id, :name, :short_name, :kana_name, :en_name, :category, :category_position, :logo_image, :note, :web_site, :created_at, :updated_at
json.url company_url(company, format: :json)
