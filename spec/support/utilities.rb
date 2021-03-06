include ApplicationHelper

def full_title(page_title)
	base_title = "Ruby on Rails Tutorial Sample App"
	if page_title.blank?
		base_title
	else
		"#{base_title} | #{page_title}"
	end
end

def valid_signin(user)
	fill_in "Email", with: user.email.upcase
	fill_in "Password", with: user.password
	click_button "Sign in"
end

def valid_signup
  fill_in "Name",         with: "Example User"
  fill_in "Email",        with: "user@example.com"
  fill_in "Password",     with: "foobar"
  fill_in "Confirm password", with: "foobar"
end

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

Rspec::Matchers.define :have_error_message do |message|
	match do |page|
		expect(page).to have_selector("div.alert.alert-error")
	end
end

Rspec::Matchers.define :have_success_message do |message|
	match do |page|
		expect(page).to have_selector("div.alert.alert-success")
	end
end