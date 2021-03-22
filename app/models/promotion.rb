class Promotion < ApplicationRecord
  has_many :coupons

  validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: true
  
  validates :code, uniqueness: true

  def generate_coupons!
    # return unless coupons.empty? #guard close
    return if coupons? #guard close

    (1..coupon_quantity).each do |number|
      self.coupons.create!(code: "#{code}-#{'%04d' % number}")
    end
  end

  # rails notes
  # TODO: fazer testes para esse método
  def coupons?
    coupons.any?
  end
end
