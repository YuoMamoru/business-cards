# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Companies", type: :request do
  before(:all) do
    @companies = [
      FactoryBot.create(:company_seq),
      FactoryBot.create(:company_seq, :category_llc_before, :logo_png),
      FactoryBot.create(:company_seq, :category_university, :logo_gif),
      FactoryBot.create(:company_seq, :logo_jpeg),
    ]
    @company = @companies.first
  end

  after(:all) do
    @companies.each do |company|
      company.destroy
    end
  end

  describe "GET /companies" do
    it "works!" do
      get companies_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /companies/new" do
    it "works!" do
      get new_company_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /companies" do
    attributes = FactoryBot.attributes_for(:company)

    it "creates company!" do
      expect {
        post companies_path, params: { company:  attributes }
        expect(response).to have_http_status(302)
      }.to change(Company.all, :count).by(1)
    end

    it "occors error when post data is invalid" do
      expect {
        post companies_path, params: { company:  attributes.merge(name: nil) }
        expect(response).to have_http_status(200)
      }.to change(Company.all, :count).by(0)
    end
  end

  describe "PUT /company/:id" do
    it "updates company!" do
      expect {
        put company_path(@company.id), params: { company:  @company.attributes.merge(name: "change") }
        expect(response).to have_http_status(302)
        expect(Company.find(@company.id).name).to_not eq @company.name
      }.to change(Company.all, :count).by(0)
    end

    it "occors error when post data is invalid" do
      expect {
        put company_path(@company.id), params: { company:  @company.attributes.merge(name: nil) }
        expect(response).to have_http_status(200)
        expect(Company.find(@company.id).name).to eq @company.name
      }.to change(Company.all, :count).by(0)
    end
  end
end
