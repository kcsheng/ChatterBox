class ApplicationController < ActionController::Base
  include SessionsHelper

  private
    def check_login
      unless logged_in?
        store_url
        flash[:danger] = 'Please log in.'
        redirect_to login_url
      end
    end
end
