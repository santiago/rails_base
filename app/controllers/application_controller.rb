# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  USERNAME, PASSWORD = "happycouple", "05976e81a7fc292bd649e9ed23d142985d82e785"

  before_filter :authenticate # , :except =>[:login]

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  helper_method :current_user_session, :current_user, :current_partner
  filter_parameter_logging :password, :password_confirmation
  before_filter :set_variables
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  def set_variables
    if current_user && current_user.partner    
      session[:partner_id] = current_user.partner.id 
      session[:my_partner_id] = current_user.partner.my_partner.id if current_user.partner.my_partner
      nsbg= current_partner.nsbg_now
      session[:has_nsbg]= nsbg.empty? || !nsbg ? false : true
    else
      session= nil
#      p "session[:partner_id]:"+session[:partner_id].to_s
    end
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = AuthlogicUserSession.find
  end
  
  def current_partner
    Partner.find(session[:partner_id])
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_logout
    if current_user_session
      current_user_session.destroy
      session= nil
    end
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
 #     redirect_to new_user_session_url
      redirect_to :controller => "front"
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
        flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def fake_login(user)
    @current_user= user
  end

  private
  def authenticate
    if RAILS_ENV == 'production'
      authenticate_or_request_with_http_basic do |username, password|
        username == USERNAME && Digest::SHA1.hexdigest(password) == PASSWORD
      end
    end
  end
end
