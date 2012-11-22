// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.autocomplete
//= require jquery.bgiframe
//= require lowpro.jquery
//= require jquery.colorbox
//= require jquery.dump
//= require application_jquery_extensions
//= require niftycube
//= require rounded
//= require application_form
//= require application_menu
//= require application_model
//= require application_inline_edit
//= require application_sidebar_list
//= require application_drag_and_drop
//= require application_add_anywhere
//= require application_table
//= require_tree .

$(document).ready(function() {
  $('input:visible:enabled:first').focus();
  $('body').keyup(function(event) {
    var targetObject = $(event.target);
    if (event.keyCode == 27 && targetObject.is('input')) {
      FormFactory.createFromEvent(event).cancel();
    }
  });
  $('body').click(function(event) {
    var eventObject = $(event.target);
    var eventObjectParent = eventObject.parent();
    if (eventObject.is('input[id*=cancel]')) {
      FormFactory.createFromEvent(event).cancel();
    } else if (eventObject.is('a[id=root_folder_expand_link]')) {
      Folders.expandAll();
    } else if (eventObject.is('a[id=sign_in_link]')) {
      new SignInAjaxForm().toggle();
    } else if (eventObject.is('a[id=root_folder_collapse_link]')) {
      Folders.collapseAll();
    } else if (eventObject.is('a[class=folder_expand_collapse_link]')) {
      new Folder(eventObject.closest('.shrink_folder')).toggle();
    } else if (eventObject.is('a[class=folder_import_link]')) {
      new FolderImportLink(eventObject).openFormPopup();
    } else if (eventObject.is('input[class=add_feature_form_type]')) {
      new AddFeatureForm().showFormArea(eventObject.attr('value'));  
    } else if (eventObject.is('a[class=feature_expand_collapse_link]')) {
      new Feature(eventObject.closest(".feature_area")).toggle();
    } else if (eventObject.is('a[class=add_tag_link]')) {
      new Feature(eventObject.closest(".feature_area")).addTag(eventObject.html());
    } else if (eventObject.is('a[id=search_results_reopen_link]')) {
      new SearchResults().reopen();
    } else if (eventObjectParent.is('a[id=search_results_close_link]')) {
      new SearchResults().close();
    } else if (eventObjectParent.is('div[class=pagination]')) {
      new SearchResults().processPageClick(event);
    }
  });
});
