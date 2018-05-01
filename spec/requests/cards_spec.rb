# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cards", type: :request do
  before(:all) do
    @cards = [
      FactoryBot.create(:card),
      FactoryBot.create(:card),
    ]
    @card = @cards.first
  end

  after(:all) do
    companies = Set.new
    @cards.each do |card|
      companies << card.company
      card.destroy
    end
    companies.each do |company|
      company.destroy
    end
  end

  describe "GET /cards" do
    it "works!" do
      get cards_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /cards/new" do
    it "works!" do
      get new_card_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /cards" do
    attributes = FactoryBot.attributes_for(:card)

    it "creates card!" do
      expect {
        post cards_path, params: {
          card:  attributes.merge(company_id: @card.company_id)
        }
        expect(response).to have_http_status(302)
      }.to change(Card.all, :count).by(1)
    end

    it "occors error when post data is invalid" do
      expect {
        post cards_path, params: {
          card:  attributes.merge(company_id: nil)
        }
        expect(response).to have_http_status(200)
      }.to change(Card.all, :count).by(0)
    end
  end

  describe "PUT /card/:id" do
    it "updates card!" do
      expect {
        put card_path(@card.id), params: { card:  @card.attributes.merge(name: "change") }
        expect(response).to have_http_status(302)
        expect(Card.find(@card.id).name).to_not eq @card.name
      }.to change(Card.all, :count).by(0)
    end

    it "occors error when post data is invalid" do
      expect {
        put card_path(@card.id), params: { card:  @card.attributes.merge(name: nil) }
        expect(response).to have_http_status(200)
        expect(Card.find(@card.id).name).to eq @card.name
      }.to change(Card.all, :count).by(0)
    end
  end

  describe "POST /card/ocr.json" do
    it "works!", google_api: true do
      post card_ocr_path(format: "json"), params: { image: fixture_file_upload("business_card.png", "image/png") }
      expect(response).to have_http_status(200)
    end
  end
end
