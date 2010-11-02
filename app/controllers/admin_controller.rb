class AdminController < ApplicationController
  before_filter :authorize, :except => ["login"]

  def login
  end
    
  def index    
    flash[:notice] = ""
    @models = {}
    @tables = {}
#
#    Dir.foreach("#{RAILS_ROOT}/app/models") do |model_path|      
#      unless model_path.split(".")[0].nil?
#        model_name= model_path.split(".")[0].capitalize 
#        model= Object.const_get(model_name)
#        @models[model_name] = {:columns=>model.column_names}
#      end
#    end

#    For development all models have to be queried to be initialized, not in production
    if(Rails.env.development?) then
      CynAnswerOption.all
      CynQuestion.all
      CynQuestionnaire.all
      Need.all
      NeedGroup.all
      NeedsKeyword.all
      NsbgHistory.all
      NsbgNow.all
      Option.all
      Partner.all
      User.all
      WucItem.all   
      ActionAgreement.all   
      ActionAgreementEvaluationQuestion.all
      CoupleQuizzesScore.all
      CoupleQuizzesQuestion.all
      CoupleQuizzesOption.all
      Game.all
      GameLocation.all
      GameCategory.all
      ContentCopy.all
      FeedbackEmail.all
      Role.all
      Feedback.all
    end
    
    ActiveRecord::Base.send(:subclasses).each do |c|
      model= Object.const_get(c.name) 
      @models[c.name] = {:columns=>model.column_names}
      @tables[c.name] = c.name.tableize.singularize
    end
    
  end


  def get_table_data
    model = Object.const_get(params[:table_name].camelize)
    @table_data = { :results => model.find(:all) }
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @table_data }
      format.json  { render :json => @table_data }
    end
    
  end
  
  def update_table_data
    id = params[:id]
    table_name = params[:table_name]
    column_name = params[:column_name]
    value = params[:value]
    
    model = Object.const_get(table_name.camelize)
    model.find(id).update_attributes({column_name=>value})    
    
  end
  
  def create_table_data
    
    table_name = params[:table_name]
    values = Hash.new
    
    model = Object.const_get(table_name.camelize)
    @new_model = model.new(params[table_name.to_sym])
      if @new_model.save
        @success = "Ok"
      else
        @success = "Error"
      end

  end
  
  def feedback
    @models = {}
    @tables = {}
    @models["FeedbackEmail"] = {:columns=>FeedbackEmail.column_names}
    @tables["FeedbackEmail"] = "FeedbackEmail".tableize.singularize
  end
  
  def feedback_delete
    resp = []
    begin
      FeedbackEmail.destroy(params[:id])
    rescue => e
      resp ={:error => e.message}
    end
    
    respond_to do |format|
      format.json  { render :json => resp }
    end
  end
  
  private
  def authorize    
    unless current_user and current_user.roles.detect {|r| r.name == "admin"}
      session[:authrized] = false
      flash[:notice] = "You need to be logged in as an administrator"
      redirect_to :action => "login"
    end
  end
end
