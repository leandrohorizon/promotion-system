class PromotionsController < ApplicationController
  before_action :set_promotion, only: [:show, :generate_coupons, :edit, :update, :destroy]
  # before_action :set_promotion, only: %i[show generate_coupons]

  def index
    @promotions = Promotion.all
  end

  def show
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.create(promotion_params)
    if @promotion.save
      redirect_to @promotion
    else
      render :new
    end
  end

  def generate_coupons
    @promotion.generate_cupons!
    redirect_to @promotion, notice: 'Cupons gerados com sucesso'
  end

  def edit
  end

  def update
    if @promotion.update(promotion_params) && @promotion.save
      redirect_to promotion_path(@promotion)
    else
      render :edit
    end
  end

  def destroy
    @promotion.destroy
    redirect_to promotions_path
  end

  private
    def promotion_params
      params
        .require(:promotion)
        .permit(:name, :expiration_date, :description, 
                :discount_rate, :code, :coupon_quantity)
    end

    def set_promotion
      @promotion = Promotion.find(params[:id])
    end
end