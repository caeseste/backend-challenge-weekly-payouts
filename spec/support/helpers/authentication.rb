# frozen_string_literal: true

module Authentication
  def login(email, password = '123456')
    @headers = {
      'Accept'=> 'application/json',
      'Content-Type'=> 'application/json',
      'authorization'=> ActionController::HttpAuthentication::Basic.encode_credentials(email,password)
    }
  end
end
