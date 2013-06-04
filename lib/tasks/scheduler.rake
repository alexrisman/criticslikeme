desc "Pull in user info from LinkedIn and see if any of it has been updated"
task :update_users => :environment do
  print "Updating user info... "
  User.updateFromLI
  puts ''
  puts "Done."
end
