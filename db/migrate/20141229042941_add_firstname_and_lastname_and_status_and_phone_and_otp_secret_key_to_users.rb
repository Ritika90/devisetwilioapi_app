class AddFirstnameAndLastnameAndStatusAndPhoneAndOtpSecretKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :status, :string
    add_column :users, :phone, :string
    add_column :users, :otp_secret_key, :string
  end
end
