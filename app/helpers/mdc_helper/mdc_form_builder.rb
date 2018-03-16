# frozen_string_literal: true

module MdcHelper
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
      @template.merge_class_name(options, *container_classes)
      container_options = { class: options.delete(:class) }
      container_options[:"data-mdc-auto-init"] = "MDCTextField" if options.delete(:auto_init) || @options[:auto_init]
      create_id(method, options)
      options[:class] = "mdc-text-field__input"
      @template.content_tag(:div, container_options) {
        label_options = { class: "mdc-floating-label", for: options[:id] }
        @template.merge_class_name(label_options, "mdc-floating-label--float-above") if @object.send(method).present?
        [
          super(method, options),
          label(method, label_options),
          @template.content_tag(:div, nil, class: "mdc-line-ripple"),
        ].join.html_safe
      }
    end

    # Create a Material Design single-option select menus using Material Components for the Web.
    #
    # === Additional optins
    #
    # * <tt>:atuto_init</tt> - If set this option to true, automatic initialization
    #   is executed using MDC-auto-init module.
    def select(method, choices = nil, options = {}, html_options = {}, &block)
      value = @object.send(method)
      container_attrs = { class: "mdc-select", role: "listbox" }
      container_attrs[:"data-mdc-auto-init"] = "MDCSelect" if options.delete(:auto_init) || @options[:auto_init]
      @template.content_tag(:div, container_attrs) {
        tabindex = options.delete(:tabindex)
        tabindex ||= "0"
        [
          @template.content_tag(:div, class: "mdc-select__surface", tabindex: tabindex) {
            label_classes = [ "mdc-select__label" ]
            label_classes << "mdc-select__label--float-above" if value.present?
            [
              @template.content_tag(:div, label_content(method), class: label_classes.join(" ")),
              @template.content_tag(:div, label_content(value), class: "mdc-select__selected-text"),
              @template.content_tag(:div, nil, class: "mdc-select__bottom-line"),
            ].join.html_safe
          },
          @template.content_tag(:div, class: "mdc-menu mdc-select__menu") {
            @template.content_tag(:ul, class: "mdc-list mdc-menu__items") {
              choices.map { |choice|
                attrs = { class: "mdc-list-item", role: "option", "data-value": choice, tabindex: "0" }
                attrs[:"aria-selected"] = "true" if value == choice
                @template.content_tag(:li, label_content(choice), attrs)
              }.join.html_safe
            }
          },
          hidden_field(method, id: create_id(method, options)),
        ].join.html_safe
      }
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
    def image_field(method, options = {})
      value = @object.send(method)
      container_options = { class: options.delete(:class) }
      @template.merge_class_name(container_options, "mdce-image-field")
      container_options[:"data-mdce-auto-init"] = "MDCEImageField" if options.delete(:auto_init) || @options[:auto_init]
      @template.content_tag(:div, container_options) {
        [
          label(method, for: create_id(method, options), class: "mdce-image-field__proxy", tabindex: options.delete(:tabindex) || "0") {
            if value.blank?
              image = @template.content_tag(:span, "Select Image...", class: "mdc-button")
            else
              image_options = {
                size: options.delete(:size),
                width: options.delete(:width),
                height: options.delete(:height),
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
            [
              image,
              file_field(method, options),
            ].join.html_safe
          },
          @template.content_tag(:div, label_content(method), class: "mdce-image-field__label mdce-image-field__label--float-above"),
        ].join.html_safe
      }
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
    # * <tt>:compact</tt> - If set this option to true, creates a button in which
    #   the amount of horizontal padding is reduced.
    # * <tt>:dense</tt> - If set this option to true, creates a button of which text
    #   is compressed to make it slightly smaller.
    # * <tt>:raised</tt> - If set this option to true, creates a button that is elevated
    #   upon the surface.
    # * <tt>:unelevated</tt> - If set this option to true, creates a button that is
    #   flush with the surface.
    def button(value = nil, options = {}, &block)
      value, options = nil, value if value.is_a?(Hash)
      elem_classes =  [ "mdc-button" ]
      elem_classes << "mdc-button--compact" if options.delete(:compact)
      elem_classes << "mdc-button--dense" if options.delete(:dense)
      elem_classes << "mdc-button--raised" if options.delete(:raised)
      elem_classes << "mdc-button--unelevated" if options.delete(:unelevated)
      @template.merge_class_name(options, *elem_classes)
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
  end
end
