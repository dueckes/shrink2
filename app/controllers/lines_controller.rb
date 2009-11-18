class LinesController < ApplicationController

  def list
  end

  def new
    @feature = Platter::Feature.find(params[:feature_id])
  end

  def cancel_create
    @feature = Platter::Feature.find(params[:feature_id])
  end

  def create
    @line = Platter::FeatureLine.new(params[:line])
    @line.feature = Platter::Feature.find(params[:feature_id])
    @line.save!
  end

  def show
    @line = Platter::FeatureLine.find(params[:id])
  end

  def edit
    @line = Platter::FeatureLine.find(params[:id])
  end

  def update
    if params[:commit] == "Update"
      @line = Platter::FeatureLine.find(params[:id])
      if !@line.update_attributes(params[:line])
        render(:update) do |page|
          page.replace_html("#{dom_id(@line)}_errors", :partial => "common/show_errors", :locals => { :errors => @line.errors })
        end
      end
    end
  end

  def destroy
    @line = Platter::FeatureLine.find(params[:id])
    @line.destroy
  end

end
