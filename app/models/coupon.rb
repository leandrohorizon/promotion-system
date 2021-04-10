class Coupon < ApplicationRecord
  belongs_to :promotion

  # enum status: [:active, :disabled]
  enum status: { 
    active: 0,
    disabled: 10,
    used: 30
  }

  delegate :discount_rate, to: :promotion
  # mesma coisa que
  # def discount_rate
  #   promotion.discount_rate
  # end
  # exclusivo do ruby

  def as_json(options = {})
    # super(methods: :discount_rate)
    # permite passar opções além do desconto
    super ({ methods: :discount_rate }.merge(options))
  end
end
