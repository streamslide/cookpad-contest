require 'fbphoto'
class HomeController < ApplicationController
  include FBPhoto
  before_filter :require_login, only: [:timeline]

  def login
    redirect_to :timeline if session[:access_token].present?
  end

  def timeline
  end

  def year_range
    years = get_yearrange(session[:access_token])
    render json: years
  end

  def photos
    photos = get_timeline(session[:access_token], params["year"].to_i)
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
