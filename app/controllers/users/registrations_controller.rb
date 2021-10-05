# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :require_no_authentication, only: [:new, :create, :cancel]
  before_action :authenticate_scope!, only: [:edit, :update, :destroy]
  before_action :set_minimum_password_length, only: [:new, :edit]

  # GET /resource/sign_up
  def new
    build_resource
    yield resource if block_given?
    respond_with resource
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    render :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    #logger.debug "■self.resource: #{self.resource.inspect}"

    # アップロードファイル <- file_field
    up_file = params[:user][:image_data]
    #logger.debug "■up_file: #{up_file.inspect}"
    # 画像ファイルが選択されていれば、検証・保存・パラメーター設定
    if up_file
      #logger.debug "■画像ファイル更新処理開始"
      # ファイルタイプが適切でないならばエラー
      case up_file.content_type
      when "image/jpeg"
        extention = ".jpg"
      when "image/png"
        extention = ".png"
      else
        #logger.debug "■画像ファイルタイプがJPEG・PNG以外のため中断"
        resource.errors.add :image_data, t('errors.messages.invalid_extension')
        render action: :edit and return
      end
      #logger.debug "■extention: #{extention}"
      # ファイルサイズが100KB以上ならばエラー
      if up_file.size >= 102400
        #logger.debug "■画像ファイルサイズが100KB以上あるため中断"
        resource.errors.add :image_data, t('errors.messages.image_file_size_too_large')
        render action: :edit and return
      else
        #logger.debug "■画像ファイルサイズは100KB未満のため続行"
      end

      # DB登録する画像ファイル名を生成
      up_file_name = resource.id.to_s + extention
      # プロフィール画像を保存するディレクトリ
      up_dir = Rails.root.join("public", "user_images")
      # アップロードするファイルのフルパス
      up_file_path = up_dir + up_file_name
      #logger.debug "■up_file_path: #{up_file_path}"
      # 前のプロフィール画像と拡張子が異なる場合は削除
      if resource.image_name != "default_image.jpg" && resource.image_name != up_file_name
        #logger.debug "■前のプロフィール画像と拡張子が異なるため削除"
        # 前のファイルを削除するためのパス
        old_file_path = up_dir + resource.image_name
        # 前のファイルを削除
        File.delete(old_file_path)
      else
        #logger.debug "■画像削除不要"
      end
      # アップロードファイルの書き込み
      File.binwrite(up_file_path, up_file.read)
      # パラメータに:image_name追加
      params[:user][:image_name] = up_file_name
      #logger.debug "■params[:user][:image_name]: #{params[:user][:image_name]}"
    else
      #logger.debug "■画像ファイル更新無し"
    end

    # 取得したパラメータで更新
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      logger.debug "■アカウント情報更新に成功"
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      # リダイレクト先を指定
      respond_with resource, location: after_update_path_for(resource)
    else
      logger.debug "■アカウント情報更新に失敗"
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  # By default we want to require a password checks on update.
  # You can overwrite this method in your own RegistrationsController.
  def update_resource(resource, params)
    #resource.update_with_password(params)
    resource.update_without_current_password(params)
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash = {})
    self.resource = resource_class.new_with_session(hash, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    #after_sign_in_path_for(resource) if is_navigational_format?
    edit_user_registration_path(resource)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    scope = Devise::Mapping.find_scope!(resource)
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    context.respond_to?(:root_path) ? context.root_path : "/"
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    #sign_in_after_change_password? ? signed_in_root_path(resource) : new_session_path(resource_name)
    sign_in_after_change_password? ?  edit_user_registration_path(resource) : new_session_path(resource_name)
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", force: true)
    self.resource = send(:"current_#{resource_name}")
  end

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end

  def account_update_params
    devise_parameter_sanitizer.sanitize(:account_update)
  end

  #def translation_scope
  #  'devise.registrations'
  #end

  private

  def set_flash_message_for_update(resource, prev_unconfirmed_email)
    return unless is_flashing_format?

    flash_key = if update_needs_confirmation?(resource, prev_unconfirmed_email)
                  :update_needs_confirmation
                elsif sign_in_after_change_password?
                  :updated
                else
                  :updated_but_not_signed_in
                end
    set_flash_message :notice, flash_key
  end

  def sign_in_after_change_password?
    return true if account_update_params[:password].blank?

    Devise.sign_in_after_change_password
  end

end
