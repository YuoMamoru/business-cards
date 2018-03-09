# frozen_string_literal: true

module MdcHelper
  # Create a Material Design link button using {Material Components for the Web}[https://material.io/components/web/].
  #
  # === Additional optins
  #
  # * <tt>:atuto_init</tt> - If set this option to true, automatic initialization
  #   is executed using MDC-auto-init module.
  def mdc_link_to(name = nil, options = nil, html_options = nil, &block)
    active_options = block_given? ? options : html_options
    active_options ||= {}
    merge_class_name(active_options, "mdc-button")
    active_options[:"data-mdc-auto-init"] = "MDCRipple" if active_options.delete(:auto_init)
    if block_given?
      options = active_options
    else
      html_options = active_options
    end
    link_to(name, options, html_options, &block)
  end

  # Create a Material Design list item link using {Material Components for the Web}[https://material.io/components/web/].
  #
  # === Additional optins
  #
  # * <tt>:icon</tt> - Specify the icon at the beginning of the list item.
  #   This method use the {Material Icons}[https://material.io/icons/].
  # * <tt>:selected</tt> - If set this option to true, the list item becomes selected state.
  def mdc_list_item_link_to(name, options = nil, html_options = nil)
    icon = html_options.delete(:icon)
    item_classes = [ "mdc-list-item" ]
    item_classes << "mdc-list-item--selected" if html_options.delete(:selected)
    merge_class_name(html_options, *item_classes)
    if icon.blank?
      link_to(name, options, html_options)
    else
      link_to(options, html_options) do
        [
          content_tag(:i, icon, class: "material-icons mdc-list-item__graphic", "aria-hidden": "true"),
          name,
        ].join(" ").html_safe
      end
    end
  end

  # Merge class attribute in <tt>options</tt> into <tt>class_names</tt>.
  #
  #   options = { id: "elem" }
  #   merge_class_name(options, "foo")
  #   options                        # => {:id =>"elem", :class=>"foo"}
  #
  #   options = { id: "elem", class: "foo" }
  #   merge_class_name(options, "bar")
  #   options                        # => {:id =>"elem", :class=>"foo bar"}
  #
  #   options = { id: "elem", class: "foo bar" }
  #   merge_class_name(options, "foo baz")
  #   options                        # => {:id =>"elem", :class=>"foo bar baz"}
  #
  #   options = { id: "elem", class: "foo bar" }
  #   merge_class_name(options, "foo", "baz")
  #   options                        # => {:id =>"elem", :class=>"foo bar baz"}
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
                attrs = { class: "mdc-list-item", role: "option", id: choice, tabindex: "0" }
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
    # * <tt>:compact</tt> - If set this option to true, create a compact button that
    #   has narrower paddings.
    # * <tt>:dense</tt> - If set this option to true, create a button to be used
    #   in dense content. The button uses smaller fonts and has narrower paddings.
    # * <tt>:raised</tt> - If set this option to true, create a raised button.
    def button(value = nil, options = {}, &block)
      value, options = nil, value if value.is_a?(Hash)
      elem_classes =  [ "mdc-button" ]
      elem_classes << "mdc-button--compact" if options.delete(:compact)
      elem_classes << "mdc-button--dense" if options.delete(:dense)
      elem_classes << "mdc-button--raised" if options.delete(:raised)
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
