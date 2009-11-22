class ScenariosController < ApplicationController

  def destroy
    @scenario = Platter::Scenario.find(params[:id])
    @scenario.destroy
  end

end
