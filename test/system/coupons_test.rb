require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase
  # TODO: o que acontece se tem mais de um cupom
  test 'disable a coupon' do
    #arrange
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                                  expiration_date: '22/12/2033')
    
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
    
    visit promotion_path(promotion)
    within 'div#coupon-natal10-0001' do
      click_on 'Desabilitar'
    end

    assert_text "Cupom #{coupon.code} desabilitado com sucesso"
    assert_text "#{coupon.code} (desabilitado)"
    within 'div#coupon-natal10-0001' do
      assert_no_link 'Desabilitar'
    end

    assert_link 'Desabilitar', cout: promotion.coupon_quantity - 1
  end
end