require 'securerandom'

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def cloudos
    auth = request.env['omniauth.auth']
    name = auth.info.name
    host = %x(hostname).strip
    host = "#{host}.cloudstead.io" unless host.include? '.'
    @user = User.find_or_create_by_username :username => name, :email => "#{name}@#{host}", :password => SecureRandom.hex
    if @user.persisted?
      Rails.logger.info 'calling sign_in_and_redirect....'
      sign_in_and_redirect @user, :event => :authentication
    else
      Rails.logger.info "o noes: #{@user.errors.full_messages}"
      redirect_to :root
    end
  end
end
