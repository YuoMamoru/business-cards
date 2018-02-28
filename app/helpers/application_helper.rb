# frozen_string_literal: true

require "base64"

module ApplicationHelper
  def base64_image_tag(image, options = {})
    return "" if image.nil?
    if options[:width] && options[:height].blank? && options[:size].blank?
      options[:height] = options[:with].to_i * image.height / image.width
    elsif options[:height] && options[:width].blank? && options[:size].blank?
      options[:width] = options[:height].to_i * image.width / image.height
    end
    image_tag(image.base64_src, options)
  end
end
