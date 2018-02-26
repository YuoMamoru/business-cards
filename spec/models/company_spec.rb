# frozen_string_literal: true

require "rails_helper"

RSpec.describe Company, type: :model do
  before do
    @company = Company.new(name: "Company Name",
                           short_name: "Comp",
                           kana_name: "comp name",
                           category: :ltd,
                           category_position: :after)
  end

  it "is valid with a name, short name, kana name, category and category position" do
    @company.valid?
    expect(@company).to be_valid
  end

  it "is invalid without a name" do
    @company.name = ""
    expect(@company).to_not be_valid
  end

  it "is invalid without a short name" do
    @company.short_name = ""
    expect(@company).to_not be_valid
  end

  it "is invalid without a kana name" do
    @company.kana_name = ""
    expect(@company).to_not be_valid
  end

  it "is invalid without a category" do
    @company.category = ""
    expect(@company).to_not be_valid
  end

  it "is invalid without a category position" do
    @company.category_position = ""
    expect(@company).to_not be_valid
  end
end
