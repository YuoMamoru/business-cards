# frozen_string_literal: true

class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  # GET /cards
  # GET /cards.json
  def index
    @cards = Card.includes(:company).order(:kana_name)
    @companies = @cards.map { |card| card.company }.uniq.sort { |a, b| a.kana_name <=> b.kana_name }
  end

  # GET /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = Card.new(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect_to cards_path, notice: t(".successfully_created") }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to cards_path, notice: t(".successfully_updated") }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url, notice: t(".successfully_destroyed") }
      format.json { head :no_content }
    end
  end

  # POST /cards/orc.json
  def ocr
    image_file = params[:image]
    image_file.open
    begin
      image = image_file.read
    ensure
      image_file.close
    end
    google_api = GoogleApi::ImageAnnotate.new(image)
    @texts = CardTextAnalyzer.new(google_api.get_text_blocks.summary&.text)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_card
    @card = Card.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def card_params
    params.require(:card).permit(:company_id, :name, :kana_name, :department, :position, :postcode, :address, :building, :tel, :cellular_phone, :fax, :mail, :front_image, :back_image, :qualification, :note)
  end
end
