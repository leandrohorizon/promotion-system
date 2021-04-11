require 'rails_helper'

describe 'Promotions test' do
  it 'view Promotions' do
    user = User.create!(email: 'teste@iugu.com.br', password: 'password')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)

    login_as user, scope: :user
    # capybara
    visit root_path
    click_on 'Promoções'
    # rspec
    expect(page).to have_text('Natal')
    expect(page).to have_text('Promoção de Natal')
    expect(page).to have_text('10,00%')
    expect(page).to have_text('Cyber Monday')
    expect(page).to have_text('Promoção de Cyber Monday')
    expect(page).to have_text('15,00%')
  end
end
