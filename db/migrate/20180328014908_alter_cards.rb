# frozen_string_literal: true

class AlterCards < ActiveRecord::Migration[5.1]
  def change
    change_column :cards, :department, :string, limit: 31
    change_column :cards, :position, :string, limit: 31
  end
end
