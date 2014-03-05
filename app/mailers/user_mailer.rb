class UserMailer < ActionMailer::Base
	default from: 'luis.anducho@hotmail.com'
	
  def following_notification(followed_user, follower)
  	@follower = follower
  	mail(to: followed_user.email, subject: "#{follower.name} is following you!")
  end

  def password_reset(user)
  	@user = user
  	mail to: user.email, subject: "Password reset"
  end
end
