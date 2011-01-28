class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :lockable and :timeoutable, :token_authenticatable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  references_one :profile, :dependent => :destroy
end
