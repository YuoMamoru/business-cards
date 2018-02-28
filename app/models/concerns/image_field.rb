# frozen_string_literal: true

module ImageField
  def image_field(*fields)
    fields.each do |field|
      instance_variable_name = :"@#{field}"
      define_method(field) {
        if instance_variable_get(instance_variable_name).nil? && super()
          instance_variable_set(instance_variable_name, Image.new(super()))
        end
      }
      define_method(:"#{field}=") { |value|
        instance_variable_set(instance_variable_name, Image.new(value))
        super(instance_variable_get(instance_variable_name).data)
      }
    end
  end
end
