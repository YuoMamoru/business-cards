# frozen_string_literal: true

require "base64"

module ApplicationHelper
  def base64_image_tag(image)
    return "" if image.nil?
    "<img src=\"#{image.base64_src}\" />".html_safe
  end
end
