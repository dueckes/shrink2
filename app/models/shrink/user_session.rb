module Shrink

  class UserSession < ::Authlogic::Session::Base
    logout_on_timeout true
    allow_http_basic_auth false
  end

end
