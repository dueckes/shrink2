authorization do

  role :normal do
    has_permission_on :users, :to => [:show, :update, :update_password] do
      if_attribute :login => is { user.login }
    end
    has_permission_on :projects, :to => :read
  end

  role :administrator do
    has_permission_on [:users, :projects], :to => :manage
  end

end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
