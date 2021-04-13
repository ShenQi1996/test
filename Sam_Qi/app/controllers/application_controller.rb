class ApplicationController < ActionController::Base
    
    helper_method :login? 


    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def login(user)
        current_user = user
        session[:session_token] = current_user.session_token
    end

    def login?
        !!current_user
    end

    def logout!
        current_user.reset_session_token!
        session[:session_token] = nil
        current_user = nil
    end

    def ensure_login
        redirect_to new_session_url unless login?
    end
end
