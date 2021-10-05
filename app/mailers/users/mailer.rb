class Users::Mailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def confirmation_instructions(record, token, opts={})
    # アカウント登録かメールアドレス変更か判定
    if record.unconfirmed_email.nil?
      # record内にユーザ情報が格納されている
      # opts属性を上書きすることで、Subjectやfromなどのヘッダー情報を変更可能。
      opts[:subject] = t('users.mailer.confirmation_instructions.subject1')
    else
      opts[:subject] = t('users.mailer.confirmation_instructions.subject2')
    end
    opts[:from] = t('users.mailer.from', mail_address: Rails.application.credentials.gmail[:address])
    super
  end

  def email_changed(record, opts = {})
    opts[:subject] = t('users.mailer.email_changed.subject')
    opts[:from] = t('users.mailer.from', mail_address: Rails.application.credentials.gmail[:address])
    super
  end

  def password_change(record, opts = {})
    opts[:subject] = t('users.mailer.password_change.subject')
    opts[:from] = t('users.mailer.from', mail_address: Rails.application.credentials.gmail[:address])
    super
  end

  def reset_password_instructions(record, token, opts = {})
    opts[:subject] = t('users.mailer.reset_password_instructions.subject')
    opts[:from] = t('users.mailer.from', mail_address: Rails.application.credentials.gmail[:address])
    super
  end

  def unlock_instructions(record, token, opts = {})
    opts[:subject] = t('users.mailer.unlock_instructions.subject')
    opts[:from] = t('users.mailer.from', mail_address: Rails.application.credentials.gmail[:address])
    super
  end

end
