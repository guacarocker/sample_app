require 'spec_helper'

describe "User pages" do

	subject { page }

  describe "Signup page" do

  	before { visit signup_path }

    it { should have_title(full_title 'Sign up') }
    it { should have_content('Sign up') }

  end

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }
	  before { visit user_path(user) }

	  it { should have_content(user.name) }
	  it { should have_title(user.name) }
	end

  describe "signup" do
    before { visit signup_path }

    let(:submit) {"Create my account"}

    describe "when submiting invalid data" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }
        it { should have_title(full_title 'Sign up') }
        it { should have_selector("div#error_explanation") }
      end
    end

    describe "when submiting valid data" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: "user@example.com") }

        it { should have_link('Sign out') }
        it { should have_title(full_title user.name) }
        it { should have_selector("div.alert.alert-success", text: "Welcome to the Sample App!") }
      end
    end
  end
end

