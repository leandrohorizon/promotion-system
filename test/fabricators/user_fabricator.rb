Fabricator(:user) do
  # email { [,].sample }
  email { sequence(:email) { |i| "jane.doe#{i}@iugu.com.br" } }
  password '123456'
end
