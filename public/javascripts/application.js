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
