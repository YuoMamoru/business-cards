# frozen_string_literal: true

require "yaml"

module MdcListHelper
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
        safe_join([
          content_tag(:i, icon.html_safe, class: "material-icons mdc-list-item__graphic", "aria-hidden": "true"),
          name,
        ], " ")
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

  # Create Material Component list with inset divider using {Material Components for the Web}[https://material.io/components/web/].
  # This helper uses <tt>RAILS_ROOT/config/divider_pattern.yml</tt>.
  #
  # This method assumes that the collection given has been sorted. If the collection
  # has been sorted, you must set <tt>:sort</tt> option to <tt>true</tt>.
  #
  # ==== Example
  #
  #   # config/divider_pattern.yml
  #   alphabetize:
  #     - key: a
  #       name: A
  #     - key: b
  #       name: B
  #     - key: c
  #       name: C
  #     # omitted below
  #
  #   # app/models/people.erb
  #   class Person < ActiveRecord::Base
  #     def name_lower
  #       name.downcase
  #     end
  #   end
  #
  #   # app/views/people/index.html.erb
  #   <%= mdc_divided_list @people, :name_lower, :alphabetize do |persion| %>
  #     <li class="mdc-list-item"><%= persion.name %></li>
  #   <% end %>
  #
  # The HTML generated for this would be (modulus formatting):
  #
  #   <h3 class="mdc-list-group__subheader">A</h3>
  #   <ul class="mdc-list">
  #     <li class="mdc-list-item">Albert</li>
  #     <li class="mdc-list-item">Alfred</li>
  #   </ul>
  #   <hr class="mdc-list-divider mdc-list-divider--inset">
  #   <h3 class="mdc-list-group__subheader">B</h3>
  #   <ul class="mdc-list">
  #     <li class="mdc-list-item">Billy</li>
  #     <li class="mdc-list-item">Brian</li>
  #   </ul>
  #   <!-- omitted below -->
  #
  # ==== Arguments
  #
  # * <tt>items</tt> - Collection that is used in loop.
  # * <tt>method</tt> - Method name that is used for segmentation.
  # * <tt>divider_pattern</tt> - Pattern of segmentation. It is a key of <tt>config/divider_pattern.yml</tt>.
  # * <tt>options</tt> - Attributes to add to the <tt>&lt;ul&gt;</tt> tag, if a key
  #   other than the additional option in the follower section is specified.
  #
  # ==== Additional options
  #
  # * <tt>:avatar_list</tt> - If set this option to true, configures the leading tiles
  #   of each row to display images instead of icons. This will make the graphics
  #   of the list items larger
  # * <tt>:dense</tt> - If set this option to true, styles the density of the list,
  #   making it appear more compact.
  # * <tt>:non_interactive</tt> - If set this option to true, disables interactivity
  #   affordances.
  # * <tt>:sort</tt> - If set this option to true, sorts items before loop.
  # * <tt>:two_line</tt> - If set this option to true, modifier to style list with two lines
  #   (primary and secondary lines).
  def mdc_divided_list(items, method, divider_pattern, options = {}, &block)
    elem_classes = [ "mdc-list" ]
    elem_classes << "mdc-list--avatar-list" if options.delete(:avatar_list)
    elem_classes << "mdc-list--dense" if options.delete(:dense)
    elem_classes << "mdc-list--non-interactive" if options.delete(:non_interactive)
    elem_classes << "mdc-list--two-line" if options.delete(:two_line)
    merge_class_name(options, *elem_classes)
    output = "".html_safe
    items = items.sort { |a, b| a.send(method) <=> b.send(method) } if options.delete(:sort)
    divider_iterator = Rails.application.config_for(:divider_pattern, env: divider_pattern.to_s).each
    current = divider_iterator.next
    items.each do |item|
      if current["key"] && (current["key"] <= item.send(method))
        while (current["key"] <= item.send(method)) || current["key"].nil?
          current = divider_iterator.next
        end
        unless item == items.first
          output << %(</ul>\n<hr class="mdc-list-divider mdc-list-divider--inset">\n).html_safe
        end
        output << %(<h3 class="mdc-list-group__subheader">#{current["name"]}</h3>\n).html_safe
        output << tag(:ul, options, true)
      end
      output << capture(item, &block)
    end
    unless items.empty?
      output << %(</ul>).html_safe
    end
    output
  end
end
