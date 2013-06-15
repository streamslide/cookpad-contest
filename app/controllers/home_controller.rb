require 'fbphoto'
class HomeController < ApplicationController
  include FBPhoto
  before_filter :require_login, only: [:timeline]

  def login
  end

  def timeline
    photos = get_timeline(session[:access_token], 2013)
    render json: photos
  end

  def callback
    auth = request.env["omniauth.auth"]
    session[:access_token] = auth[:credentials][:token]
    redirect_to :timeline
  end

  private
  def require_login
    redirect_to :login if session[:access_token].nil?
  end
end
