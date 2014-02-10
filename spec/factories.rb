FactoryGirl.define do
	factory :user do
		name									"Luis Anducho"
		email									"luis.anducho@hotmail.com"
		password							"123456"
		password_confirmation	"123456"
	end
end