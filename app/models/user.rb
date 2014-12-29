class User < ActiveRecord::Base
  # has_one_time_password column_name: :otp_secret_key, length: 4
  # Include default devise modules. Others available are:
  before_create { generate_token(:otp_secret_key) }
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def generate_token(column)
    begin
      self[column] = '%04d' % Random.rand(2..9999)
    end while User.exists?(column => self[column])
  end

end
