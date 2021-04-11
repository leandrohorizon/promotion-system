require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)

    # promotions(:one)

    visit root_path
    click_on 'Promoções'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar Promoção'

    assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    click_on 'Criar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create and code must be unique' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar Promoção'

    assert_text 'Código já está em uso'
  end

  test 'generate coupons for a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    promotion.create_promotion_approval(
      user: User.create!(email: 'john.doe@iugu.com.br', password: 'password')
    )

    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_no_text 'NATAL10-0000'
    assert_text 'NATAL10-0001'
    assert_text 'NATAL10-0002'
    assert_text 'NATAL10-0100'
    assert_no_text 'NATAL10-0101'
  end

  test 'update a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)

    click_on 'Editar Promoção'
    fill_in 'Nome', with: 'NATAL9'
    fill_in 'Descrição', with: 'Promoção de Natal'
    fill_in 'Código', with: 'NATAL99'
    fill_in 'Desconto', with: '75'
    fill_in 'Quantidade de cupons', with: '5'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Atualizar Promoção'

    assert_text 'NATAL9'
    assert_text 'Promoção de Natal'
    assert_text '75,00%'
    assert_text 'NATAL99'
    assert_text '22/12/2033'
    assert_text '5'
  end

  test 'update and attributes cannot be blank' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)

    click_on 'Editar Promoção'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''

    click_on 'Atualizar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'delete promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Pascoa', description: 'Promoção de Pascoa',
                                  code: 'PASCOA20', discount_rate: 30, coupon_quantity: 100,
                                  expiration_date: '22/12/2050', user: user)

    visit promotion_path(promotion)
    click_on 'Apagar Promoção'

    assert_no_text 'PASCOA'
    assert_no_text 'Promoção de PASCOA'
    assert_no_text '30,00%'
    assert_no_text 'PASCOA20'
    assert_no_text '22/12/2050'
    assert_no_text '30'
  end

  test 'search promotions by term and finds results' do
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

    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'Natal'
    click_on 'Buscar'

    assert_text christmas.name
    assert_text xmas.name
    assert_no_text pascoa.name
  end

  test 'user approves promotion' do
    user = User.create!(email: 'john.doe@iugu.com.br', password: 'password')
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    approver = login_user
    visit promotion_path(christmas)

    assert_emails 1 do
      accept_confirm { click_on 'Aprovar' }
    end

    # accept_confirm do
    #   click_on 'Aprovar'
    # end

    assert_text 'Promoção aprovada com sucesso'
    assert_text "Aprovada por: #{approver.email}"
    assert_link 'Gerar cupons'
  end

  test 'user approves promotion2' do
    user = login_user
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(christmas)

    refute_link 'Aprovar'
    refute_link 'Gerar cupons'
  end

  # TODO: não encontra nada
  # TODO: visitar página sem estar logado

  test 'do not view promotion link without login' do
    visit root_path
    assert_no_link 'Promoções'
  end

  test 'do not view promotions using route without login' do
    visit promotions_path

    assert_current_path new_user_session_path
  end

  test 'do view promotion details without login' do
    user = User.create!(email: 'jane.doe@iugu.com.br', password: 'password')
    promotion = Promotion.create!(name: 'Pascoa', description: 'Promoção de Pascoa',
                                  code: 'PASCOA20', discount_rate: 30, coupon_quantity: 100,
                                  expiration_date: '22/12/2050', user: user)

    visit promotion_path(promotion)

    assert_current_path new_user_session_path
  end

  test 'can not create promotion without login' do
    visit new_promotion_path
    assert_current_path new_user_session_path
  end
end
