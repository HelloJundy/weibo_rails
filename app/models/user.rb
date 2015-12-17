class User < ActiveRecord::Base
 
  attr_accessor :remember_token, :activation_token, :reset_token
  
  has_many :microposts, dependent: :destroy
  
  before_create :create_activation_digest
  before_save :email_downcase
  
  validates :name, presence: true, length:{maximum:50}
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validates :email, presence: true, length: {maximum:255}, 
            format: { with: VALID_EMAIL_REGEX}, 
            uniqueness: {case_sensitive:false }
  
  has_secure_password
  
  #虚拟属性password  由has_secure_password方法定义 数据库中是password_digest
  validates :password, presence:true, length: {minimum:6}, allow_blank: true
  
  
  
  #为了持久化，在数据库中记住用户
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
 
  #如果指定的令牌和摘要匹配，返回true
  def authenticated?(attribute, token)
     digest  = send("#{attribute}_digest")
     return false if digest.nil?
     BCrypt::Password.new(digest).is_password?(token)
     #remember_digest == User.digest(remember_token);
  end
  
  def forget
   update_attribute(:remember_digest, nil)
  end
  
  def activate
      update_attribute(:activated, true)
      update_attribute(:activated_at, Time.zone.now)
  end
  
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  def sent_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  #如果密碼重設超時則返回true
  def password_reset_expired
    reset_sent_at < 2.hours.ago
  end
  
  class << self
    # 返回指定字符串的哈希摘要
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
    #返回一個令牌
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
  
  private
  
    def email_downcase
      self.email.downcase!
    end
    
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
