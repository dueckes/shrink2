class LinesController < ApplicationController
  set_model_class Platter::FeatureLine
  set_model_name_in_view :line

  def destroy
    @line = Platter::FeatureLine.find(params[:id])
    @line.destroy
  end

end
