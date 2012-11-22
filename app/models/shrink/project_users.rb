module Shrink

  module ProjectUsers
    include Shrink::ActiveRecord::OptionManipulation

    def find_unassigned_with_normal_role_and_similar_login(login)
      Shrink::User.joins(:role).where(find_unassigned_with_normal_role_and_similar_login_conditions(login)).all
    end

    private
    def find_unassigned_with_normal_role_and_similar_login_conditions(login)
      conditions = [%{lower(login) like lower(?) and #{Shrink::Role.table_name}.name = ?}, "#{login}%", "normal"]
      unless project.users.empty?
        conditions = merge_conditions_including_values(
                conditions, ["#{Shrink::User.table_name}.id not in (?)", project.users.collect(&:id)])
      end
      conditions
    end

    def project
      proxy_association.owner
    end

  end

end