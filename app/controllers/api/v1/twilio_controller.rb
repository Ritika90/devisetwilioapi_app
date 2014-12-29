require 'twilio-ruby'
class Api::V1::TwilioController < ApplicationController
  include Webhookable
  skip_before_action :verify_authenticity_token
  def voice
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Hey there. Congrats on integrating Twilio into your Rails 4 app.', :voice => 'alice'
      r.Play 'http://linode.rabasa.com/cantina.mp3'
    end
    render_twiml response
  end

  def otp_conf
    @user = User.find_by_otp_secret_key(params[:user][:otp])
    if @user == nil
      render :json => {:user => { :status => "Enter valid OTP"}}
    else
    @user.confirmed_at = Time.now
    @user.otp_secret_key = nil
    @user.confirmation_token = nil
    @user.save
    render :json => {:user => { :status => "Your account has been confirmed and now you can log in into your account"}}
    end
  end
end


