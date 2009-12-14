# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Similar to div_for but produces an li tag
  def li_for(record, *args, &block)
    content_tag_for(:li, record, *args, &block)
  end

  def nested_dom_id(symbol, parent=nil)
    dom_id(parent || @parent, symbol)
  end

  def element_style(options)
    options[:hidden] ? "display: none;" : ""
  end

  def forgery_protection_request_parameter
    if respond_to?('protect_against_forgery?') && protect_against_forgery?
      "'#{request_forgery_protection_token}=' + encodeURIComponent('#{escape_javascript form_authenticity_token}')"
    else
      ""
    end
  end

  def draggable_link_remote_function(options)
    "if (!this.dragged) #{remote_function(options)}; this.dragged = false"
  end

  def folder_feature_link(feature)
    ajax_request = draggable_link_remote_function(:url => { :controller => :features, :action => :show_detail, :id => feature.id })
    link_to_function feature.title, ajax_request,
                     { :id => dom_id(feature, :folder_link), :class => "folder_feature_link", :title => "View Feature" }
  end

  def refresh_folder(page, folder)
    page << "$('##{dom_id(folder)}').fadeOut('fast')"
    if folder.root?
      page.replace("#{dom_id(folder)}", :partial => "folders/show_root", :locals => { :root_folder => folder, :feature => nil})
    else
      page.replace("#{dom_id(folder)}", :partial => "folders/show", :locals => { :folder => folder, :feature => nil, :hidden => true})
    end
    page << "$('##{dom_id(folder)}').fadeIn('fast')"
    page << "Folders.makeDragAndDroppable(#{forgery_protection_request_parameter})"
    page << "FolderFeatures.makeDraggable()"
  end

end
