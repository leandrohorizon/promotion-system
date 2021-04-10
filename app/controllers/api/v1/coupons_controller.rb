class Api::V1::CouponsController < Api::V1::ApiController # modulo api modulo v1 classe couponscontroller
  # respond_to :json
  def show
    # find by com bang retorna erro e pode ser recuperado pelo rescue
    # active procura todos os ativos
    @coupon = Coupon.active.find_by!(code: params[:code])
    # Coupon.where(status: :active).where().where.not()

    # TODO @coupon = Coupon.where(status: [:active, :available], code: params[:code])

    # where quando é mais de 1
    # head 200 # renderiza status de sucesso

    # render status: :success, json: @coupon.to_json

    # render json: @coupon # .to_json
    # render json: @coupon.as_json(except: [:promotion_id], include: [:promotion])
    
    # render json: { discount_rate: @coupon.promotion.discount_rate }

    # retorna todos os atributos do cupom e o desconto
    # render json: @coupon.as_json(methods: :discount_rate)

    # return render json: @coupon if @coupon # guard close
    # @coupon.present? @coupon.blank?

    # render status 404
    # render json: '', status: :not_found
  end

  def index
    @coupons = Coupon.all
    render json: @coupon.as_json(include: :promotion)
  end
end