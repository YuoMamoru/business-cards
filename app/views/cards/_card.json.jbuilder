# frozen_string_literal: true

json.extract! card, :id, :company, :name, :kana_name, :department, :position, :postcode, :address, :tel, :fax, :mail, :front_image, :back_image, :qualification, :note, :created_at, :updated_at
json.url card_url(card, format: :json)
