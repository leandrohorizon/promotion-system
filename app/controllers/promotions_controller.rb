class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all
  end

  def show
    set_promotion
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
    set_promotion

    (1..@promotion.coupon_quantity).each do |number|
      Coupon.create!(code: "#{@promotion.code}-#{'%04d' % number}", promotion: @promotion)
    end

    flash[:notice] = 'Cupons gerados com sucesso'
    redirect_to @promotion
  end

  def edit
    set_promotion
  end

  def update
    set_promotion
    if @promotion.update(promotion_params) && @promotion.save
      redirect_to promotion_path(@promotion)
    else
      render :edit
    end
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