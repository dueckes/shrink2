module FoldersHelper

  def folder_feature_link(feature)
    ajax_request = draggable_link_remote_function(:url => { :controller => :features, :action => :show_detail, :id => feature.id })
    link_to_function feature.title, ajax_request,
                     { :id => dom_id(feature, :folder_link), :class => "folder_feature_link", :title => "View Feature" }
  end

  def refresh_folder(page, folder)
    page << "$('##{dom_id(folder)}').fadeOut('fast')"
    if folder.root?
      page.replace("#{dom_id(folder)}", :partial => "folders/show_root", :locals => { :root_folder => folder, :highlighted_feature => nil})
    else
      page.replace("#{dom_id(folder)}", :partial => "folders/show", :locals => { :folder => folder, :highlighted_feature => nil, :hidden => true})
    end
    page << "$('##{dom_id(folder)}').fadeIn('fast')"
    page << "Folders.makeDragAndDroppable(#{forgery_protection_request_parameter})"
    page << "FolderFeatures.makeDraggable()"
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

end
