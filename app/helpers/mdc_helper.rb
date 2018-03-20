# frozen_string_literal: true

module MdcHelper
  # Create a Material Design button using {Material Components for the Web}[https://material.io/components/web/].
  # See ActionView::Helpers::FormTagHelper#button_tag for options and attributes.
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
  def mdc_button_tag(content_or_options = nil, options = nil, &block)
    if content_or_options.is_a? Hash
      options = content_or_options
    else
      options ||= {}
    end
    elem_classes =  [ "mdc-button" ]
    elem_classes << "mdc-button--dense" if options.delete(:dense)
    elem_classes << "mdc-button--raised" if options.delete(:raised)
    elem_classes << "mdc-button--unelevated" if options.delete(:unelevated)
    merge_class_name(options, *elem_classes)
    options[:"data-mdc-auto-init"] = "MDCRipple" if options.delete(:auto_init)
    button_tag(content_or_options, options, &block)
  end

  # Create a Material Design floating action button (FAB) using {Material Components for the Web}[https://material.io/components/web/].
  #
  # === Additional optins
  #
  # * <tt>:atuto_init</tt> - If set this option to true, automatic initialization
  #   is executed using MDC-auto-init module.
  # * <tt>:mini</tt> - If set this option to true, creates a FAB to a smaller size.
  # * <tt>:exited</tt> - If set this option to true, creates a animates the FAB out of view.
  def mdc_fab(icon, options = {})
    elem_classes = ["mdc-fab", "material-icons"]
    elem_classes << "mdc-fab--mini" if options.delete(:mini)
    elem_classes << "mdc-fab--exited" if options.delete(:exited)
    merge_class_name(options, *elem_classes)
    options[:"data-mdc-auto-init"] = "MDCRipple" if options.delete(:auto_init)
    if options[:label].present? && options[:"aria-label"].blank?
      options[:"aria-label"] = options.delete(:label)
    end
    button_tag(options) do
      content_tag(:span, icon, class: "mdc-fab__icon")
    end
  end

  # Create a Material Design link button using {Material Components for the Web}[https://material.io/components/web/].
  # See ActionView::Helpers::UrlHelper#link_to for signegure or options.
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
  def mdc_link_to(name = nil, options = nil, html_options = nil, &block)
    active_options = block_given? ? options : html_options
    active_options ||= {}
    elem_classes =  [ "mdc-button" ]
    elem_classes << "mdc-button--dense" if active_options.delete(:dense)
    elem_classes << "mdc-button--raised" if active_options.delete(:raised)
    elem_classes << "mdc-button--unelevated" if active_options.delete(:unelevated)
    merge_class_name(active_options, *elem_classes)
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
  # ==== Signatures
  #
  #   mdc_list_item_link_to(name, url, html_options = {})
  #     # url is a String; you can use URL helpers like
  #     # posts_path
  #
  #   mdc_list_item_link_to(name, url_options = {}, html_options = {})
  #     # url_options, except :method, is passed to url_for
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

  # Create a meta item link with icon in a Material Design list using {Material Components for the Web}[https://material.io/components/web/].
  # For the argument <tt>icon</tt>, specifies icon name of the {Material Icons}[https://material.io/icons/].
  #
  # ==== Signatures
  #
  #   mdc_list_item_meta_icon_link_to(icon, url, html_options = {})
  #     # url is a String; you can use URL helpers like
  #     # posts_path
  #
  #   mdc_list_item_meta_icon_link_to(icon, url_options = {}, html_options = {})
  #     # url_options, except :method, is passed to url_for
  #
  # === Additional optins
  #
  # * <tt>:label</tt> - Specifies label of icon.
  def mdc_list_item_meta_icon_link_to(icon, options, html_options)
    merge_class_name(html_options, "mdc-list-item__meta", "material-icons")
    if html_options[:label].present? && html_options[:"aria-label"].blank?
      html_options[:"aria-label"] = html_options.delete(:label)
    end
    link_to(icon, options, html_options)
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
end
