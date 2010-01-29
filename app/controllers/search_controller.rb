class SearchController < ApplicationController

  before_filter :verify_text
  before_filter :establish_text

  RESULTS_PER_PAGE = 5

  def all
    @tags = current_project.tags.find(:all, :conditions => ["lower(name) like ?", "%#{@search_text.downcase}%"])
    features
  end

  def features
    @features = current_project.features.paginate(:all,
            :conditions => ["lower(summary) like ?", "%#{@search_text.downcase}%"], :order => "title asc",
            :page => params[:page], :per_page => RESULTS_PER_PAGE)
  end

  private
  def verify_text
    render_errors("search_errors", ["Search text required"]) if params[:text].blank?
  end

  def establish_text
    @search_text = params[:text]
  end

end
