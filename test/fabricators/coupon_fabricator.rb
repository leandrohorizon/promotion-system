Fabricator(:coupon) do
  code { sequence(:code) }
  promotion
  status :active
  # before_save { |coupon, transient| coupon.code = promotion.code }
  before_create do |coupon, _transient|
    coupon.code = "#{coupon.promotion.code}-#{format('%04d', (coupon.code.to_i + 1))}"
  end
end
