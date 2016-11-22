require 'securerandom'

class User < ApplicationRecord
  has_many :tracks
  enum auth_type: [:registred, :temporary]
  validates :password, confirmation: true, if: :registred?
  after_initialize :set_default_values
  before_save :genrate_unic_login, if: :temporary?
  
  def set_default_values
    self.auth_type ||= 'registred'
  end
  
  def genrate_unic_login 
    self.login ||= SecureRandom.uuid.gsub('-','')
  end
  
  def registration!
    self.password = User.password_encrypt_method(password)
    self.password_confirmation = User.password_encrypt_method(password_confirmation)
    
    #save
    self.registred!
  end
  
  def self.log_in params
    return User.find_by login: params[:login], password: User.password_encrypt_method(params[:password])
  end
  
  def self.create_temp
    return User.create auth_type: 'temporary'
  end
  
  protected
  def self.password_encrypt_method password
    return Digest::MD5.hexdigest password
  end
end
