require 'fbphoto'
class HomeController < ApplicationController
  include FBPhoto
  before_filter :require_login, only: [:timeline]

  def login
    redirect_to :timeline if session[:access_token].present?
  end

  def timeline
    access_token = session[:access_token]
    @user = User.create_from_access_token access_token
    session[:user_id] = @user.id
  end

  def year_range
    years = get_yearrange(session[:access_token])
    render json: years
  end

  def photos
    current_year = DateTime.now.year
    year = params["year"].to_i
    timestamp = Time.new(year, 01, 01).to_i

    user_id = session[:user_id]
    is_use_db = false

    if year < current_year
      photos = Image.where(['created_timestamp > ?', timestamp]).where(:user_id => user_id).order(:created_timestamp)
      is_use_db = true if not photos.empty?
    end

    if not is_use_db
      photos = get_timeline(session[:access_token], year)
      Image.where(['created_timestamp > ?', timestamp]).where(:user_id => user_id).destroy_all if year == current_year
      Image.store_images user_id, photos
    end

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
