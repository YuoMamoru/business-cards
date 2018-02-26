# frozen_string_literal: true

class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name, limit: 255, null: false
      t.string :short_name, limit: 31, null: false
      t.string :kana_name, limit: 255, null: false
      t.string :en_name, limit: 255
      t.integer :category, limit: 2, null: false
      t.integer :category_position, limit: 1, null: false
      t.binary :logo_image_data
      t.string :note, limit: 255
      t.string :web_site, limit: 255

      t.timestamps
    end

    add_index :companies, :kana_name
  end
end
