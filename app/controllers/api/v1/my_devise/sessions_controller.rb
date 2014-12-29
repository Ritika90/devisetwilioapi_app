class Api::V1::MyDevise::SessionsController < Devise::SessionsController

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    yield resource if block_given?
    render :json => {:user => {:email => current_user.email, :status => "Signed In successfully"}}
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    yield if block_given?
    render :json => {:user => { :status => "Signed Out successfully"}}
  end

  protected

  def sign_in_params
    devise_parameter_sanitizer.sanitize(:sign_in)
  end

  def serialize_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { methods: methods, only: [:password] }
  end

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end

  def verify_signed_out_user
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    yield if block_given?
    render :json => {:user => { :status => "Signed Out successfully"}}
  end
end
