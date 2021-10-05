class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
   :registerable,
   :recoverable,
   :rememberable,
   :trackable,
   :validatable,
   :confirmable,
   :lockable
  
  validates :name, presence: true
  validates :password, presence: true, on: :create
  validates :image_data, acceptance: true, on: :update
  
  validate :password_complexity
  
  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,70}$/

    errors.add :password, I18n.t('errors.messages.password_not_complex')
  end

  def update_without_current_password(params, *options)
    params.delete(:current_password)
    params.delete(:image_data)
    
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    # update_attributesでデータベースの値を複数同時に更新。「result = 」は消さないよう注意。
    result = update_attributes(params, *options)
    # passwordとpassword_confirmationの値をnilにする
    clean_up_passwords
    result
  end

end
