# frozen_string_literal: true

module MdcFormTagHelper
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
    elem_classes = [ "mdc-button" ]
    elem_classes << "mdc-button--dense" if options.delete(:dense)
    elem_classes << "mdc-button--raised" if options.delete(:raised)
    elem_classes << "mdc-button--unelevated" if options.delete(:unelevated)
    merge_class_name(options, *elem_classes)
    options[:"data-mdc-auto-init"] = "MDCRipple" if options.delete(:auto_init)
    button_tag(options) do
      if block_given?
        content_tag(:span, class: "mdc-button__label", &block)
      else
        content_tag(:span, content_or_options || "Button", class: "mdc-button__label")
      end
    end
  end

  # Create a Material Design icon button.
  # This method use the {Material Icons}[https://material.io/icons/].
  def mdc_icon_button_tag(icon, options = {})
    merge_class_name(options, "material-icons res-icon-button")
    button_tag(icon, options)
  end

  # Create a Material Design floating action button (FAB) using {Material Components for the Web}[https://material.io/components/web/].
  #
  # === Additional optins
  #
  # * <tt>:atuto_init</tt> - If set this option to true, automatic initialization
  #   is executed using MDC-auto-init module.
  # * <tt>:exited</tt> - If set this option to true, creates a animates the FAB out of view.
  # * <tt>:label</tt> - Specifies a label of the FAB.
  # * <tt>:mini</tt> - If set this option to true, creates a FAB to a smaller size.
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

  # Create a Material Design floating action button (FAB) for page transition
  # using {Material Components for the Web}[https://material.io/components/web/].
  #
  # === Additional optins
  #
  # * <tt>:atuto_init</tt> - If set this option to true, automatic initialization
  #   is executed using MDC-auto-init module.
  # * <tt>:exited</tt> - If set this option to true, creates a animates the FAB out of view.
  # * <tt>:label</tt> - Specifies a label of the FAB.
  # * <tt>:mini</tt> - If set this option to true, creates a FAB to a smaller size.
  #
  # ==== Examples
  # Because it relies on +url_for+, +mdc_fab_link_to+ supports both older-style
  # controller/action/id arguments and newer RESTful routes. Current Rails style
  # favors RESTful routes whenever possible, so base your application on resources
  # and use
  #
  #   mdc_fab_link_to "person", profile_path(@profile)
  #   # => '<a href="/profiles/1" class="mdc-fab material-icons">
  #   #      <span class="mdc-fab__icon">person</span>
  #   #    </a>'
  #
  # or the even pithier
  #
  #   mdc_fab_link_to "person", @profile
  #   # => '<a href="/profiles/1" class="mdc-fab material-icons">
  #   #      <span class="mdc-fab__icon">person</span>
  #   #    </a>'
  #
  # in place of the older more verbose, non-resource-oriented
  #
  #   mdc_fab_link_to "person", controller: "profiles", action: "show", id: @profile
  #   # => '<a href="/profiles/show/1" class="mdc-fab material-icons">
  #   #      <span class="mdc-fab__icon">person</span>
  #   #    </a>'
  #
  # to specify the options as following
  #
  #   mdc_fab_link_to "person", @profile, mini: true
  #
  # when non-resource-oriented
  #
  #   mdc_fab_link_to "person", {controller: "profiles", action: "show", id: @profile}, mini: true
  def mdc_fab_link_to(icon, url, options = {})
    elem_classes = ["mdc-fab", "material-icons"]
    elem_classes << "mdc-fab--mini" if options.delete(:mini)
    elem_classes << "mdc-fab--exited" if options.delete(:exited)
    merge_class_name(options, *elem_classes)
    options[:"data-mdc-auto-init"] = "MDCRipple" if options.delete(:auto_init)
    if options[:label].present? && options[:"aria-label"].blank?
      options[:"aria-label"] = options.delete(:label)
    end
    link_to(url, options) do
      content_tag(:span, icon, class: "mdc-fab__icon")
    end
  end

  # Create a Material Design check box using {Material Components for the Web}[https://material.io/components/web/].
  # See ActionView::Helpers::FormTagHelper#check_box_tag for options and attributes.
  #
  # === Additional optins
  #
  # * <tt>:align_end</tt> - If set this option to true, positions the label before the input.
  # * <tt>:atuto_init</tt> - If set this option to true, automatic initialization
  #   is executed using MDC-auto-init module.
  # * <tt>:label</tt> - Specifies label content.
  def mdc_check_box_tag(name, value = "1", checked = false, options = {})
    form_classes = [ "mdc-form-field" ]
    form_classes << "mdc-form-field--align-end" if options.delete(:align_end)
    form_options = { class: form_classes.join(" ") }
    container_classes = [ "mdc-checkbox" ]
    container_classes << "mdc-checkbox--disabled" if options[:disabled]
    merge_class_name(options, *container_classes)
    container_options = { class: options.delete(:class) }
    container_options[:"data-mdc-auto-init"] = "MDCCheckbox" if options.delete(:auto_init)
    label = options.delete(:label)
    check_box =
      content_tag(:div, container_options) do
        safe_join([
          check_box_tag(name, value, checked, options.merge(class: "mdc-checkbox__native-control")),
          content_tag(:div, class: "mdc-checkbox__background") do
            safe_join([
              content_tag(:svg, class: "mdc-checkbox__checkmark", viewBox: "0 0 24 24") do
                content_tag(:path, nil, class: "mdc-checkbox__checkmark-path", fill: "none", stroke: "white", d: "M1.73,12.91 8.1,19.28 22.79,4.59")
              end,
              content_tag(:div, nil, class: "mdc-checkbox__mixedmark"),
            ])
          end,
        ])
      end
    if label.blank?
      check_box
    else
      content_tag(:div, form_options) do
        safe_join([
          check_box,
          label_tag(options[:id].blank? ? name : options[:id], label),
        ])
      end
    end
  end

  # Create a Material Design switch using {Material Components for the Web}[https://material.io/components/web/].
  # See ActionView::Helpers::FormTagHelper#check_box_tag for options and attributes.
  #
  # === Additional optins
  #
  # * <tt>:label</tt> - Specifies label content.
  def mdc_switch(name, value = "1", checked = false, options = {})
    container_classes = [ "mdc-switch" ]
    container_classes << "mdc-switch--checked" if checked
    merge_class_name(options, *container_classes)
    container_options = { class: options.delete(:class) }
    container_options[:"data-mdc-auto-init"] = "MDCSwitch" if options.delete(:auto_init)
    label = options.delete(:label)
    sw = content_tag(:div, container_options) do
      safe_join([
        content_tag(:div, nil, class: "mdc-switch__track"),
        content_tag(:div, class: "mdc-switch__thumb-underlay") do
          content_tag(:div, class: "mdc-switch__thumb") do
            check_box_tag(name, value, checked, options.merge(class: "mdc-switch__native-control", role: "switch", "aria-checked": checked))
          end
        end
      ])
    end
    if label.blank?
      sw
    else
      safe_join([
        sw,
        label_tag(options[:id].blank? ? name : options[:id], label),
      ], "\n")
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
    elem_classes = [ "mdc-button" ]
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
end
