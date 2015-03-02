class RatingsController < ApplicationController



  def index

    #Expireaa 15 minuutin välein.
    Rails.cache.write("beer top 3", Beer.top(3), expires_in:15.minutes) if not_in_cache
    Rails.cache.write("brewery top 3", Brewery.top(3), expires_in:15.minutes) if not_in_cache
    Rails.cache.write("style top 3", Style.top(3), expires_in:15.minutes) if not_in_cache
    Rails.cache.write("user top 5", User.top(5), expires_in:15.minutes) if not_in_cache


    @breweries = Rails.cache.read "brewery top 3"
    @beers = Rails.cache.read "beer top 3"
    @styles = Rails.cache.read "style top 3"
    @users = Rails.cache.read "user top 5"

    @ratings = Rating.recent
  end

  #tarkistaa löytyykö kaikki cachesta
  def not_in_cache
    fragment_exist?( "brewery top 3" )
    fragment_exist?( "beer top 3" )
    fragment_exist?( "user top 5" )
    fragment_exist?( "style top 3" )
  end


  def create_oauth
    byebug
  end

  ##Päivittää taustalla, poistettu kuitenkin nyt käytöstä
  def background_updater
    while true do
      sleep 25.minutes
      Rails.cache.write("beer top 3", Beer.top(3))
      Rails.cache.write("brewery top 3", Brewery.top(3))
      Rails.cache.write("style top 3", Style.top(3))
      Rails.cache.write("user top 5", User.top(5))
    end


  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating  ## virheen aiheuttanut rivi
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end