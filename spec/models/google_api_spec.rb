# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GoogleApi of images:annotate", type: :model do
  before do
    @google_api = GoogleApi::ImageAnnotate.new("\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x01\x03\x00\x00\x00%\xDBV\xCA\x00\x00\x00\x03PLTE\x00\x00\x00\xA7z=\xDA\x00\x00\x00\x01tRNS\x00@\xE6\xD8f\x00\x00\x00\nIDAT\x08\xD7c`\x00\x00\x00\x02\x00\x01\xE2!\xBC3\x00\x00\x00\x00IEND\xAEB`\x82")
  end

  it "returns image properties", google_api: true do
    properties = @google_api.get_properties
    expect(properties.dominant_colors.size).to eq 1
    expect(properties.dominant_colors.first.hex).to eq "#FFFFFF"
    expect(properties.dominant_colors.first.score).to eq 1
  end

  it "return text in image", google_api: true do
    text_blocks = @google_api.get_text_blocks
    expect(text_blocks.summary).to be_nil
  end
end
