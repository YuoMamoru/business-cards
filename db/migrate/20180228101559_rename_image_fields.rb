# frozen_string_literal: true

class RenameImageFields < ActiveRecord::Migration[5.1]
  def change
    rename_column :companies, :logo_image_data, :logo_image
  end
end
