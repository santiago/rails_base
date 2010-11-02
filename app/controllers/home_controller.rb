class HomeController < ApplicationController
  
  before_filter :require_user, :only => [:index, :heid]
  protect_from_forgery :except => [:index]


  include Domain::Partners  
  include Domain::CYN

  def index
    @partner= Partner.find(session[:partner_id])

    @nsbg= partner_nsbg_now(session[:partner_id])
    @photos = partner_home_page_photos(session[:partner_id])
    @partner_wylayp= get_wylayp_for_partner(session[:partner_id])
    @has_partner_link_request = has_partner_link_request(session[:partner_id])
    @is_linked = is_linked(session[:partner_id])
    @partner_link_request_code= @partner.partner_link_request_code
    @code= @partner_link_request_code
  end

  # GET /heid
  def heid
    @nsbg= partner_nsbg_now(session[:partner_id])
    render :partial => "heid"
  end
  
  # GET /heid/my-partner
  def my_partner_heid
    @nsbg= Partner.find(session[:partner_id]).my_partner.nsbg_now
    render :partial => "heid"
  end

  def photos
    @photos = partner_home_page_photos(session[:partner_id])
    respond_to do |format|
      format.json  { render :json => resp }
      format.html  { render :layout => false }
    end
    
  end
  
  def partner_photos
    @photos = []
    @photos = partner_home_page_photos(session[:my_partner_id]) if session[:my_partner_id]
    respond_to do |format|
      format.json  { render :json => resp }
      format.html  { render :layout => false }
    end
    
  end
  
  def post_save_photo
    save_photo session[:partner_id], params[:photo_title], params[:upload]
    redirect_to '/home'
  end
  
  def post_save_photo_ajax
    save_photo_ajax session[:partner_id], params[:photo_title], params[:Filename], params[:Filedata]
  end  
  
  def about
    @at_home_page= true
  end
end
