# frozen_string_literal: true

module MdcFormHelper
  # An +MdcFormBuilder+ object is associated with a particular model object and
  # allows you to generate Material Design fields associated with the model object.
  # The fields is generated using {Material Design for the Web}[https://material.io/components/web/].
  # The +MdcFormBuilder+ is used in +form_with+, +form_for+ or +fields_for+.
  #
  # === Examples
  #
  #   <%= form_with(model: @post, builder: MdcHelper::MdcFormBuilder) do |form| %>
  #     <%= form.text_field :title, id: :post_title %>
  #   <% end %>
  #
  # If you use <tt>:auto_init</tt> option, MDC-component is initialized automatically.
  #
  #   <%= form_with(model: @post, :auto_init: true, builder: MdcHelper::MdcFormBuilder) do |form| %>
  #     <%= form.text_field :title, id: :post_title %>
  #   <% end %>
  #
  # Helper mehtods also have <tt>:auto_init</tt> option, so the following example
  # works the same as the above.
  #
  #   <%= form_with(model: @post, builder: MdcHelper::MdcFormBuilder) do |form| %>
  #     <%= form.text_field :title, id: :post_title, :auto_init: true %>
  #   <% end %>
  class MdcFormBuilder < ActionView::Helpers::FormBuilder
    include OptionHelper

    # Create a Material Design text field using Material Components for the Web.
    #
    # === Additional optins
    #
    # * <tt>:atuto_init</tt> - If set this option to true, automatic initialization
    #   is executed using MDC-auto-init module.
    # * <tt>:dense</tt> - If set this option to true, create a text field to be used
    #   in dense content. The field uses smaller fonts and has narrower paddings.
    def text_field(method, options = {})
      container_classes = [ "mdc-text-field" ]
      container_classes << "mdc-text-field--dense" if options.delete(:dense)
      container_classes << "mdc-text-field--disabled" if options[:disabled]
      merge_class_name(options, *container_classes)
      container_options = { class: options.delete(:class) }
      container_options[:"data-mdc-auto-init"] = "MDCTextField" if options.delete(:auto_init) || @options[:auto_init]
      create_id(method, options)
      options[:class] = "mdc-text-field__input"
      @template.content_tag(:div, container_options) do
        label_options = { class: "mdc-floating-label", for: options[:id] }
        merge_class_name(label_options, "mdc-floating-label--float-above") if @object.send(method).present?
        @template.safe_join([
          super(method, options),
          label(label_content(method), label_options),
          @template.content_tag(:div, nil, class: "mdc-line-ripple"),
        ])
      end
    end

    # Create a Material Design single-option select menus using Material Components for the Web.
    #
    # === Additional optins
    #
    # * <tt>:atuto_init</tt> - If set this option to true, automatic initialization
    #   is executed using MDC-auto-init module.
    # * <tt>:box</tt> - If set this option to true, styles the select as a box select.
    def select(method, choices = nil, options = {}, html_options = {}, &block)
      container_classes = [ "mdc-select" ]
      container_classes << "mdc-select--box" if options.delete(:box)
      merge_class_name(html_options, *container_classes)
      container_options = { class: html_options.delete(:class) }
      container_options[:"data-mdc-auto-init"] = "MDCSelect" if options.delete(:auto_init) || @options[:auto_init]
      create_id(method, html_options)
      html_options[:class] = "mdc-select__native-control"
      @template.content_tag(:div, container_options) do
        @template.safe_join([
          super,
          @template.content_tag(:div, label_content(method), class: "mdc-floating-label"),
          @template.content_tag(:div, nil, class: "mdc-line-ripple"),
        ])
      end
    end

    # Create a file upload field for image file. This component uses an input tag
    # of the "file" type, but it looks like a button. If the field related has
    # an image, the component show the image, which looks like image button.
    # When a user designates an image file, the component shows a preview of the image.
    #
    # === Additional optins
    #
    # * <tt>:atuto_init</tt> - If set this option to true, automatic initialization
    #   is executed.
    # * <tt>:height</tt> - Specifies the height of image. <tt>:height</tt> will be
    #   ignored if <tt>:size</tt> is specified. The width is adjusted to maintain
    #   the aspect ratio if <tt>:size</tt> and <tt>:width</tt> is not specified.
    # * <tt>:max_height</tt> - Specifies the maximum height of image. This opetion
    #   is implemented using style of img tag.
    # * <tt>:max_width</tt> - Specifies the maximum height of image. This opetion
    #   is implemented using style of img tag.
    # * <tt>:size</tt> - Supplied as "{Width}x{Height}" or "{Number}", so "30x45" becomes
    #   width="30" and height="45", and "50" becomes width="50" and height="50".
    #   <tt>:size</tt> will be ignored if the value is not in the correct format.
    # * <tt>:width</tt> - Specifies the width of image. <tt>:width</tt> will be
    #   ignored if <tt>:size</tt> is specified. The height is adjusted to maintain
    #   the aspect ratio if <tt>:size</tt> and <tt>:height</tt> is not specified.
    def image_field(method, options = {})
      value = @object.send(method)
      container_options = { class: options.delete(:class) }
      merge_class_name(container_options, "mdce-image-field")
      container_options[:"data-mdce-auto-init"] = "MDCEImageField" if options.delete(:auto_init) || @options[:auto_init]
      @template.content_tag(:div, container_options) do
        style_options = []
        style_options << "max-width:#{options.delete(:max_width)}px" if options.has_key?(:max_width)
        style_options << "max-height:#{options.delete(:max_height)}px" if options.has_key?(:max_height)
        style_attr = style_options.empty? ? nil : style_options.join(";")
        @template.safe_join([
          label(method, for: create_id(method, options), class: "mdce-image-field__proxy", tabindex: options.delete(:tabindex) || "0", style: style_attr) do
            if value.blank?
              select_button = @template.content_tag(:span, "#{image_default_value}...", class: "mdc-button mdce-image-field__button")
              image = nil
            else
              select_button = @template.content_tag(:span, "#{image_default_value}...", class: "mdc-button mdce-image-field__button", style: "display:none")
              image_options = {
                size: options.delete(:size),
                width: options.delete(:width),
                height: options.delete(:height),
                class: "mdce-image-field__image",
                style: style_attr,
              }
              image = @template.base64_image_tag(value, image_options)
            end
            if options[:style].blank?
              options[:style] = "display:none"
            else
              if options[:style].to_s[-1] == ";"
                options[:style] = "#{options}display:none"
              else
                options[:style] = "#{options};display:none"
              end
            end
            @template.safe_join([
              select_button,
              image,
              file_field(method, options),
            ])
          end,
          @template.content_tag(:div, label_content(method), class: "mdce-image-field__label mdce-image-field__label--float-above"),
        ])
      end
    end

    # This helper method behaves like <tt>button</tt> method, but it does not accept
    # a block.
    def submit(value = nil, options = {})
      button(value, options)
    end

    # Create a Material Design button using Material Components for the Web.
    #
    # === Additional optins
    #
    # * <tt>:atuto_init</tt> - If set this option to true, automatic initialization
    #   is executed using MDC-auto-init module.
    # * <tt>:dense</tt> - If set this option to true, creates a button of which text
    #   is compressed to make it slightly smaller.
    # * <tt>:raised</tt> - If set this option to true, creates a button that is elevated
    #   upon the surface.
    # * <tt>:unelevated</tt> - If set this option to true, creates a button that is
    #   flush with the surface.
    def button(value = nil, options = {}, &block)
      value, options = nil, value if value.is_a?(Hash)
      elem_classes = [ "mdc-button" ]
      elem_classes << "mdc-button--dense" if options.delete(:dense)
      elem_classes << "mdc-button--raised" if options.delete(:raised)
      elem_classes << "mdc-button--unelevated" if options.delete(:unelevated)
      merge_class_name(options, *elem_classes)
      options[:"data-mdc-auto-init"] = "MDCRipple" if options.delete(:auto_init) || @options[:auto_init]
      super(value, options, &block)
    end

    private

    def create_id(method, options)
      options[:id] = "#{object_name}_#{method}" if options[:id].blank?
      options[:id]
    end

    def label_content(method_or_text)
      return "" if method_or_text.blank?
      content = ActionView::Helpers::Tags::Translator.new(@object, object_name, method_or_text, scope: "helpers.label").translate
      content ||= method_or_text.humanize
      content
    end

    def image_default_value
      object = convert_to_model(@object)

      model = if object.respond_to?(:model_name)
        object.model_name.human
      else
        @object_name.to_s.humanize
      end

      defaults = []
      defaults << :"helpers.image.#{object_name}.select"
      defaults << :"helpers.image.select"

      I18n.t(defaults.shift, model: model, default: defaults)
    end
  end
end
