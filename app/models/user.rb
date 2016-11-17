require 'securerandom'

class User < ApplicationRecord
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
end
