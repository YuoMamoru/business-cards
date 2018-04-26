# frozen_string_literal: true

class AddCorporateColor < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :color, :string, limit: 7
  end
end
