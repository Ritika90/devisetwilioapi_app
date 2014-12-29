class Api::V1::MyDevise::ConfirmationsController < Devise::ConfirmationsController

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token]).save
    if self.resource == true
      render :json => {:user => { :status => "Your email id has been confirmed and now you can login into your account"}}
    else
      render :json => {:user => { :status => false}}
    end
  end


end