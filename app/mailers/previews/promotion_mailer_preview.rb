class PromotionMailerPreview < ActionMailer::Preview
  def approval_email
    PromotionMailer
      .with(user: User.first, promotion: Promotion.first)
      .approval_email
    # link para visualizar o e-mail /rails/mailers/
  end
end
