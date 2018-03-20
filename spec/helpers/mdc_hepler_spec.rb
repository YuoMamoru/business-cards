# frozen_string_literal: true

require "rails_helper"

RSpec.describe MdcHelper, type: :helper do
  describe "#merge_class_name" do
    it "adds class attribute if option have no class attribute" do
      options = { id: "elm_id" }
      merge_class_name(options, "foo")
      expect(options[:class]).to eq "foo"
    end

    it "adds class-name if it is given unknown class-name" do
      options = { id: "elm_id", class: "foo" }
      merge_class_name(options, "bar")
      expect(options[:class]).to eq "foo bar"
    end

    it "does nothing if it is given known class-name" do
      options = { id: "elm_id", class: "foo" }
      merge_class_name(options, "foo")
      expect(options[:class]).to eq "foo"
    end

    it "merges class-names if it is given known class-name and unknown class-name" do
      options = { id: "elm_id", class: "foo bar" }
      merge_class_name(options, "foo baz")
      expect(options[:class]).to eq "foo bar baz"
    end

    it "can receive three arguments" do
      options = { id: "elm_id", class: "foo bar" }
      merge_class_name(options, "foo", "baz")
      expect(options[:class]).to eq "foo bar baz"
    end
  end
end
