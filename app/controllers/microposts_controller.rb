class MicropostsController < ApplicationController
	before_action :signed_in_user
	before_action :correct_user, only: [:destroy]
	
	def create
		if @micropost.content.index(/(d\s[A-Za-z0-9_]{1,15})/) == 0
			user_string = @micropost.content.match(/d\s([A-Za-z0-9_]{1,15})/)[1]
			user = User.find_by(username: user_string)
			direct_message = current_user.sent_messages.build(user, @content)
			if direct_message.save
				flash[:success] = "The message has been sent."
				redirect_to root_url
			else
				flash[:error] = "The message couldn't be sent."
				redirect_to root_url
		else
			codigo de abajo
		end
		
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_url
	end

	private
	def micropost_params
		params.require(:micropost).permit(:content)
	end

	def correct_user
		@micropost = current_user.microposts.find_by(id: params[:id])
		redirect_to root_url if @micropost.nil?
	end
end