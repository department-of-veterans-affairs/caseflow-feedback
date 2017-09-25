# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# Repopulate Admin list on each 'rake db:seed' run
initial_size = Admin.count
Admin.delete_all
File.foreach(Rails.root.join('db', 'seeds', 'admins.yml')) {|css_id| Admin.create(css_id: css_id.strip) unless css_id.blank? }
new_size = Admin.count
puts "****************************************************************************************************************************"
puts "****************************************************************************************************************************"
puts
puts
puts "Admin records before seeding: #{initial_size}"
puts "Admin records after seeding:  #{new_size}"
puts
puts "****************************************************************************************************************************"
puts "****************************************************************************************************************************"
