require "test_helper"

class PromotionTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    promotion = Promotion.new

    refute promotion.valid?
    assert_includes promotion.errors[:name], 'não pode ficar em branco'
    assert_includes promotion.errors[:code], 'não pode ficar em branco'
    assert_includes promotion.errors[:discount_rate], 'não pode ficar em '\
                                                      'branco'
    assert_includes promotion.errors[:coupon_quantity], 'não pode ficar em'\
                                                        ' branco'
    assert_includes promotion.errors[:expiration_date], 'não pode ficar em'\
                                                        ' branco'
  end

  test 'code must be uniq' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    promotion = Promotion.new(code: 'NATAL10')

    refute promotion.valid?
    assert_includes promotion.errors[:code], 'já está em uso'
  end

  test '#generate_coupons! succesfully' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    
    promotion.generate_coupons!
    # assert promotion.coupons.size == promotion.coupon_quantity
    assert_equal promotion.coupons.size, promotion.coupon_quantity
    assert_equal promotion.coupons.first.code, 'NATAL10-0001'
  end

  test 'generate_coupons! cannot be called twice' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    Coupon.create!(code: 'BLABLABLA', promotion: promotion)
    assert_no_difference 'Coupon.count' do
      promotion.generate_coupons!
    end
  end

  test '.search promotions by exact' do
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    pascoa = Promotion.create!(name: 'Pascoa', description: 'Promoção de Pascoa',
                                  code: 'PASCOA20', discount_rate: 30, coupon_quantity: 100,
                                  expiration_date: '22/12/2050')

    result = Promotion.search('Natal')
    assert_includes result, christmas
    refute_includes result, pascoa
  end

  test '.search promotions by partial' do
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    xmas = Promotion.create!(name: 'Natalina', description: 'Promoção de Natal',
                            code: 'NATAL11', discount_rate: 10, coupon_quantity: 100,
                            expiration_date: '22/12/2033')

    pascoa = Promotion.create!(name: 'Pascoal', description: 'Promoção de Pascoa',
                                  code: 'PASCOA20', discount_rate: 30, coupon_quantity: 100,
                                  expiration_date: '22/12/2050')

    result = Promotion.search('Natal')
    assert_includes result, christmas
    assert_includes result, xmas
    refute_includes result, pascoa
  end

  test '.search find nothing' do
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    xmas = Promotion.create!(name: 'Natalina', description: 'Promoção de Natal',
                            code: 'NATAL11', discount_rate: 10, coupon_quantity: 100,
                            expiration_date: '22/12/2033')

    pascoa = Promotion.create!(name: 'Pascoal', description: 'Promoção de Pascoa',
                                  code: 'PASCOA20', discount_rate: 30, coupon_quantity: 100,
                                  expiration_date: '22/12/2050')

    result = Promotion.search('carnaval')
    assert_empty result
  end
end
