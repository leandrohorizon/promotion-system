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
  
  SEARCHABLE_FIELD = %w[name code description].freeze
  def self.search(query)
    # Promotion.where(name: query)
    # where(name: query)

    # where('name LIKE :query', query: "%LOWER(#{query})%")
    # where('name LIKE ?', "%LOWER(#{query})%") # .limit(5)

    where(
      SEARCHABLE_FIELD
      .map { |field| "#{field} LIKE :query" }
      .join(' OR '),
      query: "%#{query}%")
      .limit(5)
  end
end
