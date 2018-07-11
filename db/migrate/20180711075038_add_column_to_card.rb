# frozen_string_literal: true

class AddColumnToCard < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :cellular_phone, :string, limit: 15
  end
end
