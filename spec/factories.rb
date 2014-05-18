FactoryGirl.define do
	factory :user do
		name	"Justin Mullis"
		email	"justin@example.com"
		password "foobar"
		password_confirmation "foobar"
	end
end