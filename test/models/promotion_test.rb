require 'test_helper'

class PromotionTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    promotion = Promotion.new

    assert_not promotion.valid?
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
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    promotion = Promotion.new(code: 'NATAL10')

    assert_not promotion.valid?
    assert_includes promotion.errors[:code], 'já está em uso'
  end

  test '#generate_coupons! succesfully' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    promotion.generate_coupons!
    # assert promotion.coupons.size == promotion.coupon_quantity
    assert_equal promotion.coupons.size, promotion.coupon_quantity
    assert_equal promotion.coupons.first.code, 'NATAL10-0001'
  end

  test 'generate_coupons! cannot be called twice' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    Coupon.create!(code: 'BLABLABLA', promotion: promotion)
    assert_no_difference 'Coupon.count' do
      promotion.generate_coupons!
    end
  end

  test '.search promotions by exact' do
    user = login_user
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    pascoa = Promotion.create!(name: 'Pascoa', description: 'Promoção de Pascoa',
                               code: 'PASCOA20', discount_rate: 30, coupon_quantity: 100,
                               expiration_date: '22/12/2050', user: user)

    result = Promotion.search('Natal')
    assert_includes result, christmas
    assert_not_includes result, pascoa
  end

  test '.search promotions by partial' do
    user = login_user
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    xmas = Promotion.create!(name: 'Natalina', description: 'Promoção de Natal',
                             code: 'NATAL11', discount_rate: 10, coupon_quantity: 100,
                             expiration_date: '22/12/2033', user: user)

    pascoa = Promotion.create!(name: 'Pascoal', description: 'Promoção de Pascoa',
                               code: 'PASCOA20', discount_rate: 30, coupon_quantity: 100,
                               expiration_date: '22/12/2050', user: user)

    result = Promotion.search('Natal')
    assert_includes result, christmas
    assert_includes result, xmas
    assert_not_includes result, pascoa
  end

  test '.search find nothing' do
    user = login_user
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    xmas = Promotion.create!(name: 'Natalina', description: 'Promoção de Natal',
                             code: 'NATAL11', discount_rate: 10, coupon_quantity: 100,
                             expiration_date: '22/12/2033', user: user)

    pascoa = Promotion.create!(name: 'Pascoal', description: 'Promoção de Pascoa',
                               code: 'PASCOA20', discount_rate: 30, coupon_quantity: 100,
                               expiration_date: '22/12/2050', user: user)

    result = Promotion.search('carnaval')
    assert_empty result
  end
end
