# frozen_string_literal: true

class ChangeAddressColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :cards, :address, :string, limit: 127
    add_column :cards, :building, :string, limit: 127
  end
end
