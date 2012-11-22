module Shrink
  module Acceptance
    class Role

      attr_reader :name, :username, :password

      def self.from_name(name)
        ALL.find { |role| role.name == name }.tap do |role|
          raise "Role with name '#{name}' not found" unless role
        end
      end

      private

      def initialize(name, username, password)
        @name = name
        @username = username
        @password = password
        ALL << self
      end

      public

      ALL = []
      ADMIN = Role.new("administrator", "admin", "admin")

    end
  end
end
