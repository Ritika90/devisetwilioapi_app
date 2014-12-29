class Api::V1::MyDevise::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  prepend_before_filter :require_no_authentication, only: [ :new, :create, :cancel ]

  # POST /resource
  def create
    # sign_up_params = params[:user]
    build_resource(sign_up_params)
    resource.skip_confirmation_notification!
    resource_saved = resource.save
    if @user.status == "message"
      client = Twilio::REST::Client.new 'AC37a6bc10aed8d0298ae2cb1a6500ee8a', 'a2f4a6fd9f71a6f8c855157bab046c3a'
      message = client.messages.create from: '+19136672012', to: "#{resource.phone}", body: "Hello there, your OTP is #{resource.otp_secret_key}"
      resource.confirmation_sent_at = Time.now
      resource.save
    else
      resource.send_confirmation_instructions
    end
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        # set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        render :json => {:user => {:email => current_user.email, :status => "User Created & Signed_In"}}
      else
        expire_data_after_sign_in!
        render :json => {:user => { :status => "Confirmation message has been sent to you"}}
      end
    end

  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.sanitize(:sign_up) { |u|
      u.permit( :firstname, :lastname, :email, :password, :password_confirmation, :status, :phone)
    }
  end

  private

  def sign_up_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation, :status, :phone)
  end

end
