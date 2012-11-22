module Shrink
  class Database

    def self.clear
      Shrink::Project.destroy_all
      Shrink::Folder.destroy_all
      Shrink::Feature.destroy_all
      Shrink::Tag.destroy_all
      Shrink::User.destroy_all(["login != ?", "admin"])
      Shrink::Role.destroy_all(["name not in(?)", %w(administrator normal)])
    end

  end
end
