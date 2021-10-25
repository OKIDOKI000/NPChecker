class Users::Mailer < Devise::Mailer
  # application_helperのヘルパーを使えるようにする
  helper :application
  # URLヘルパーを使えるようにする
  include Devise::Controllers::UrlHelpers
  default template_path: 'users/mailer'

  # 引数
  #   record: user
  #   token: トークン
  #   opts: 追加オプション付きのhash。Subjectやfromなどのヘッダー情報を変更可能。

  def confirmation_instructions(record, token, opts={})
    # アカウント登録かメールアドレス変更か判定
    if record.unconfirmed_email.nil?
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

  def notice_np(user, nps)
    @user = user
    @nps = nps
    m_from = t('users.mailer.from', mail_address: Rails.application.credentials.gmail[:address])
    mail( subject: t('users.mailer.notice_np.subject'),
          to: @user.email,
          from: m_from,
          reply_to: m_from,
          template_path: 'users/mailer',
          template_name: 'notice_np'
        )
  end

end
