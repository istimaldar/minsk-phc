class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :vkontakte, :twitter]

  def self.find_for_oauth(access_token)
    if @user = User.where("provider = ? AND uid = ?",
                          access_token.provider,
                          access_token.uid).first
      @user
    else
      @user = User.create(access_token)
      @user.save
      @user
    end
  end

  private
  def self.create(access_token)
    @user = User.new(:provider => access_token.provider,
                     :uid => access_token.uid,
                     :username => access_token.info.name,
                     :image => access_token.info.image,
                     :email => "#{access_token.uid}@temp.tmp",
                     :password => Devise.friendly_token[0,20])
    @user
  end
end
