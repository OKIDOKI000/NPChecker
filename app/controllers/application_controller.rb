class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  
  def configure_permitted_parameters
    added_attrs = [ :name,
                    :email,
                    :password,
                    :image_name,
                    :image_data
                  ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    
    # 基本の記載方法は以下
    #devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :image_name])
  end

end
