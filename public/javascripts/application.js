$(document).ready(function() {
  $('#fold_menu .expand_link').click(function () {
    var foldItemObject = $(this).closest('.fold_item');
    FoldMenuItemFactory.createFromObject(foldItemObject).toggle();
  }),
  $('body').keyup(function(event) {
    var targetObject = $(event.target);
    if (event.keyCode == 27 && targetObject.is('input')) {
      FormFactory.createFromEvent(event).cancel();
    }
  }),
  $('body').click(function(event) {
    var eventObject = $(event.target);
    if (eventObject.is('input[id*=cancel]')) {
      FormFactory.createFromEvent(event).cancel();
    } else if (eventObject.is('a[id=root_folder_expand_link]')) {
      Folders.expandAll();
    } else if (eventObject.is('a[id=root_folder_collapse_link]')) {
      Folders.collapseAll();
    } else if (eventObject.is('a[class=folder_expand_collapse_link]')) {
      new Folder(eventObject.closest('.platter_folder')).toggle();
    } else if (eventObject.is('a[id*=expand_collapse_link]')) {
      new Feature(eventObject.closest(".feature_area")).toggle();
    } else if (eventObject.is('a[class=add_tag_link]')) {
      new Feature(eventObject.closest(".feature_area")).addTag(eventObject.html());
    }
  })
});
