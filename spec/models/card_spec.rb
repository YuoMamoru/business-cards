# frozen_string_literal: true

require "rails_helper"

RSpec.describe Card, type: :model do
  before do
    @card = FactoryBot.build(:card)
  end

  it "is valid with a company, name, kana name" do
    expect(@card).to be_valid
  end

  it "is invalid without a company" do
    @card.company = nil
    expect(@card).to be_invalid
  end

  it "is invalid without a name" do
    @card.name = ""
    expect(@card).to be_invalid
  end

  it "is invalid when its name in too long" do
    @card.name = "0" * 32
    expect(@card).to be_invalid
  end

  it "is invalid without a kana name" do
    @card.kana_name = ""
    expect(@card).to be_invalid
  end

  it "is invalid when its kana name is too long" do
    @card.kana_name = "0" * 64
    expect(@card).to be_invalid
  end

  it "is valid when its department is not too long" do
    @card.department = "0" * 31
    expect(@card).to be_valid
  end

  it "is invalid when its department is too long" do
    @card.department = "0" * 32
    expect(@card).to be_invalid
  end

  it "is valid when its position is not too long" do
    @card.position = "0" * 31
    expect(@card).to be_valid
  end

  it "is invalid when its position is too long" do
    @card.position = "0" * 32
    expect(@card).to be_invalid
  end

  it "is valid with a valid postcode" do
    @card.postcode = "123-4567"
    expect(@card).to be_valid
  end

  it "is invalid with a invalid postcode" do
    @card.postcode = "1234-567"
    expect(@card).to be_invalid
  end

  it "is valid when its address is not too long" do
    @card.address = "0" * 127
    expect(@card).to be_valid
  end

  it "is invalid when its address is too long" do
    @card.address = "0" * 128
    expect(@card).to be_invalid
  end

  it "is valid when its building is not too long" do
    @card.building = "0" * 127
    expect(@card).to be_valid
  end

  it "is invalid when its building is too long" do
    @card.building = "0" * 128
    expect(@card).to be_invalid
  end

  it "is valid with a valid tel" do
    @card.tel = "012-345-6789"
    expect(@card).to be_valid
  end

  it "is invalid with a invalid tel" do
    @card.tel = "123-456-7890"
    expect(@card).to be_invalid
    @card.tel = "012(345)6789"
    expect(@card).to be_invalid
  end

  it "is invalid when its tel is too long" do
    @card.tel = "01234-56789-0123"
    expect(@card).to be_invalid
  end

  it "is valid with a valid cellular phone" do
    @card.cellular_phone = "012-345-6789"
    expect(@card).to be_valid
  end

  it "is invalid with a invalid cellular phone" do
    @card.cellular_phone = "123-456-7890"
    expect(@card).to be_invalid
    @card.cellular_phone = "012(345)6789"
    expect(@card).to be_invalid
  end

  it "is invalid when its cellular phone is too long" do
    @card.cellular_phone = "01234-56789-0123"
    expect(@card).to be_invalid
  end

  it "is valid with a valid fax" do
    @card.fax = "012-345-6789"
    expect(@card).to be_valid
  end

  it "is invalid with a invalid fax" do
    @card.fax = "123-456-7890"
    expect(@card).to be_invalid
    @card.fax = "012(345)6789"
    expect(@card).to be_invalid
  end

  it "is invalid when its fax is too long" do
    @card.fax = "01234-56789-0123"
    expect(@card).to be_invalid
  end

  it "is valid with a valid mail" do
    @card.mail = "#{'a' * 243}@test.domain"
    expect(@card).to be_valid
  end

  it "is invalid with a invalid mail" do
    @card.mail = "account@domain"
    expect(@card).to be_invalid
  end

  it "is invalid when its fax is too long" do
    @card.mail = "#{'a' * 244}@test.domain"
    expect(@card).to be_invalid
  end

  it "is valid when its qualification is not too long" do
    @card.qualification = "0" * 255
    expect(@card).to be_valid
  end

  it "is invalid when its qualification is too long" do
    @card.qualification = "0" * 256
    expect(@card).to be_invalid
  end

  it "is valid when its note is not too long" do
    @card.note = "0" * 255
    expect(@card).to be_valid
  end

  it "is invalid when its note is too long" do
    @card.note = "0" * 256
    expect(@card).to be_invalid
  end
end
