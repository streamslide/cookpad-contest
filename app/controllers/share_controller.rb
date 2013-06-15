class ShareController < ApplicationController
  def index
    @share_key = params["share_key"]
  end

  def photos
    year = params["year"].to_i
    timestamp = Time.new(year, 01, 01).to_i
    photos = Image.where(['created_timestamp > ?', timestamp]).where(:user_id => user.id).order(:created_timestamp)
    render json: photos
  end

  def year_range
    timestamp = Image.where(:user_id => user.id).order(:created_timestamp).limit(1)[0].created_timestamp
    min_year = Time.at(timestamp).year
    current_year = Time.new.year
    years = (min_year..current_year).to_a
    render json: years
  end

  private
  def user
    @share_key = params["share_key"]
    User.find_by_share_key(@share_key)
  end

end
