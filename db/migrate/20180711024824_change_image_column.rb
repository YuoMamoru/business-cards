# frozen_string_literal: true

class ChangeImageColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :companies, :logo_image, :binary, limit: 1.megabyte
    change_column :cards, :front_image, :binary, limit: 1.megabyte
    change_column :cards, :back_image, :binary, limit: 1.megabyte
  end
end
