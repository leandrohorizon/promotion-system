module LoginHelper
  def login_user(user = User.create!(email: 'jane.doe@iugu.com.br', password: 'password'))
    login_as user, scope: :user
  end
end