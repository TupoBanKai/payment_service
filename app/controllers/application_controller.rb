class ApplicationController < ActionController::Base
  def current_client
    @current_client ||= Client.last # авторизацию не делаю
  end
end
