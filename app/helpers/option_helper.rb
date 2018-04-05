# frozen_string_literal: true

module OptionHelper
  private

  def merge_class_name(options, *class_name)
    class_names =
      class_name.inject([]) do |classes, cn|
        classes.concat(cn.strip.split(/ +/)) if cn.present?
        classes
      end
    if options[:class].blank?
      options[:class] = class_names.join(" ")
    else
      current_classes = options[:class].strip.split(/ +/)
      options[:class] =
        class_names.inject(current_classes) { |classes, cn|
          classes << cn unless current_classes.include?(cn)
          classes
        }.join(" ")
    end
  end
end
