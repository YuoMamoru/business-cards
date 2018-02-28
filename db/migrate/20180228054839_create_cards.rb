# frozen_string_literal: true

class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.references :company, null: false
      t.string :name, limit: 31, null: false
      t.string :kana_name, limit: 63, null: false
      t.string :department
      t.string :position
      t.string :postcode, limit: 8
      t.string :address, limit: 255
      t.string :tel, limit: 15
      t.string :fax, limit: 15
      t.string :mail, limit: 255
      t.binary :front_image
      t.binary :back_image
      t.string :qualification, limit: 255
      t.string :note, limit: 255
      t.boolean :deleted, default: false, null: false

      t.timestamps
    end
  end
end
