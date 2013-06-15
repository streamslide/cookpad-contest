require 'fbphoto'
class HomeController < ApplicationController
  include FBPhoto

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
end
