class Api::V1::CouponsController < Api::V1::ApiController # modulo api modulo v1 classe couponscontroller
  def show
    @coupon = Coupon.find_by(code: params[:code])
    # where quando é mais de 1
    # head 200 # renderiza status

    # render status: :success, json: @coupon.to_json

    render json: @coupon # .to_json
  end
end