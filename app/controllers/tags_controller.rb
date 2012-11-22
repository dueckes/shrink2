class TagsController < ResourceApplicationController
  helper StepsHelper

  append_before_filter :establish_parents_via_params, :only => [:new, :create]
end
