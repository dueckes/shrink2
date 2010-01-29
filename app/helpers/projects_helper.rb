module ProjectsHelper

  def render_dashboard_js(project, model_classes, recently_changed_features)
    replace_main_inner_js(render("projects/show", :project => project, :model_classes => model_classes,
                                 :recently_changed_features => recently_changed_features))
  end

end
