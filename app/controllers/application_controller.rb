class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def current_client
    @current_client ||= Client.last # авторизацию не делаю
  end
end
