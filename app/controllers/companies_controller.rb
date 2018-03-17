# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :update]

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1.json
  def show
  end

  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.json { render :show, status: :created, location: @company }
      else
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.json { render :show, status: :ok, location: @company }
      else
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = Company.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def company_params
    params.require(:company).permit(:name, :short_name, :kana_name, :en_name, :category, :category_position, :logo_image, :note, :web_site)
  end
end
