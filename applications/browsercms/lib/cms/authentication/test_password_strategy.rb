  module Authentication
    # For testing external authentication.
    class TestPasswordStrategy < Devise::Strategies::Authenticatable
      EXPECTED_LOGIN = EXPECTED_PASSWORD = 'test'
      def authenticate!
        if(authentication_hash[:login] == password && password == EXPECTED_PASSWORD)
          user = ExternalUser.authenticate(authentication_hash[:login], 'Test Password', {first_name: "Test", last_name: "User"})
          user.authorize('cms-admin', 'content-editor')
          success!(user)
        else
          pass
        end
      end
    end
  end
