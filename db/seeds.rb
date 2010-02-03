Shrink::Role.create!(:name => "normal", :description => "Can manage features within projects in which they are assigned")
admin_role = Shrink::Role.create!(:name => "administrator", :description => "Can manage users, projects and features within projects")
Shrink::User.create!(:login => "admin", :password => "admin", :password_confirmation => "admin", :role => admin_role)
