module FoldersHelper

  def folder_feature_link(feature)
    link_to feature.title, { :controller => :features, :action => :show_detail, :id => feature.id },
            { :remote => true, 'data-draggable' => true, :id => dom_id(feature, :folder_link), :class => "folder_feature_link", :title => "View Feature" }
  end

  def refresh_folder_js(folder)
    %{
      $('##{dom_id(folder)}').fadeOutAndIn(function(object) {
        object.replaceWith(#{::ActiveSupport::JSON.encode(render_folder_to_string(:folder => folder))});
        #{make_folders_and_features_drag_and_droppable_js}
      })
    }
  end

  def make_folders_and_features_drag_and_droppable_js
    %{
      Folders.makeDragAndDroppable(#{forgery_protection_request_parameter});
      FolderFeatures.makeDraggable();
    }
  end

  def folder_in_feature_path?(folder, feature)
    !feature || folder.in_tree_path_until?(feature.folder)
  end

  def expand_collapse_title(expanded)
    expanded ? "Collapse" : "Expand"
  end

  def folder_feature_link_area_class(feature, highlighted_feature)
    element_class = "folder_feature_area"
    element_class += " highlighted" if feature == highlighted_feature
    element_class
  end

  def render_folder_to_string(options)
    if options[:folder].root?
      render("folders/show_root", :root_folder => options[:folder], :highlighted_feature => options[:highlighted_feature])
    else
      render("folders/show", :folder => options[:folder], :highlighted_feature => options[:feature], :hidden => false)
    end
  end

  def show_move(page, script)
    # setTimeout addresses jQuery defect when removing dropped element - see http://dev.jqueryui.com/ticket/4550
    page << "setTimeout(function() { #{script} }, 500)"
  end

end
