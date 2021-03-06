class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    @greeting = "Hi " + user.firstname

    mail to: user.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user

    mail to: user.email, subject: "Password reset"
  end


  def invitation_accepted(user, current_user)
    @user = user
    @acceptedBy = current_user
    mail to: user.email, subject: "Invitation has been accepted."
  end

  def invitation_sent(user, current_user)
    @user = user
    @invitedBy = current_user
    mail to: user.email, subject: "You have received an invitation to create a new connection."
  end

  def invitation_rejected(user, current_user)
    @user = user
    @rejectedBy = current_user
    mail to: user.email, subject: "Your invitation has been rejected."
  end


end
