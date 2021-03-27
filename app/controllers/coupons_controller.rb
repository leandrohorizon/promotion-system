class CouponsController < ApplicationController
  def disable
    @coupon = Coupon.find(params[:id])
    @coupon.disabled!
    # desabilitar
    redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code)
  end
end