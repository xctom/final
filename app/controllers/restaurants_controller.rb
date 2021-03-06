class RestaurantsController < ApplicationController
	
	before_action :check_configuration
  before_action :set_page_id

  #set page id for menu tab
  def set_page_id
		@page_id = "restaurants"
	end

	#check if there is already a configuration
  #otherwise create a configuration
	def check_configuration
		if Yelp.client.configuration == nil 

			Yelp.client.configure do |config|
			  config.consumer_key = "qOxoGstzEM4ERC_BQxIltw"
			  config.consumer_secret = "Tk1TpsaLK5aaSLTFgEfSDWhOkMQ"
			  config.token = "Hdr0_0BjpxnItY1LtfNl-MrNEzIZbXvX"
			  config.token_secret = "AXuqW-YSbjWrLmtgSDdJStG2_G0"
			end
		end
	end

	def index

    if params[:page] && params[:page].to_i > 0
      page = params[:offset].to_i
      @restaurants = Restaurant.order("rating desc").page params[:page]
    else
      @restaurants = Restaurant.order("rating desc").page 0
    end

  end

  def show

    restaurant = Restaurant.find_by(id:params[:id])

    if restaurant

      @business = Yelp.client.business(restaurant.yelp_id)
      @posts = restaurant.posts.order("id desc")

    else
      redirect_to restaurants_path, notice: "No restaurant record!"
    end

  end
end