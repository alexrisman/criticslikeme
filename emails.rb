a = User.all
name = Array.new
email = Array.new
a.each do |u|
	if u.linkedin_secret
		client = LinkedIn::Client.new("q1iihtxz0jdp", "zcRTqafcns6LqZwG")
		client.authorize_from_access(u.linkedin_token, u.linkedin_secret)
		c = client.profile(:fields => ["first-name", "email-address"])
		name.push c.first_name
		email.push c.email_address
	end
end
print name
print email