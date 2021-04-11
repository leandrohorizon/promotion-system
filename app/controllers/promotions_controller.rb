class PromotionsController < ApplicationController
  before_action :authenticate_user! # , only: [:index, :show, :new, :create, :generate_coupons]
  before_action :set_promotion, only: %i[show generate_coupons edit update destroy approve]
  # before_action :set_promotion, only: %i[show generate_coupons]

  before_action :can_be_approved, only: [:approve]

  def index
    @promotions = Promotion.all
  end

  def show; end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = current_user.promotions.new(promotion_params)
    # @promotion.user = current_user
    if @promotion.save
      redirect_to @promotion
    else
      render :new
    end
  end

  def generate_coupons
    @promotion.generate_coupons!
    redirect_to @promotion, notice: t('.success')
  end

  def edit; end

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

  def search
    @promotions = Promotion.search(params[:query])
    render :index
  end

  def approve
    # PromotionApproval.create!(promotion: @promotion, user: current_user)
    current_user.promotion_approvals.create!(promotion: @promotion)
    PromotionMailer
      .with(promotion: @promotion, approver: current_user)
      .approval_email
      .deliver_now
    # deliver_later quando é muito e-mail para ser enviado assync
    redirect_to @promotion, notice: 'Promoção aprovada com sucesso'
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

  def can_be_approved
    redirect_to @promotion, alert: 'Ação não permitida' unless @promotion.can_approve?(current_user)
  end
end
