# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include AssetsHelpers
  
  ANSWER_OPTION_TYPE = {:select=> 1, :radio=>2, :checkbox=>3, :textarea=>4, :text=>5}
  GENDERS = {:male=> 'M', :female=>'F'}
  def all_needs
    Need.all
  end
  
  def need_name(need_id)
    Need.find(need_id).name
  end
  
  def all_options_by_domain(domain)
    Option.find_all_by_domain(domain)
  end
  
  def partner_login(partner_id)
    AuthlogicUser.find(Partner.find(partner_id).user_id).login
  end
  
  def copy(domain)
    ContentCopy.find_by_domain(domain).copy
  end
  
  def lipsum
    "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  end

  def short_lipsum
    "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
  end

  def truncate_nsbg_label(label)
    t=""
    words= label.split(" ")
    words.each { |w| t << "#{w[0..6]} "}
    t
  end
end
