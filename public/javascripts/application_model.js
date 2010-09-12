var ModelObject = $.klass({
  initialize: function(areaSelector) {
    this._area = $(areaSelector);
  },
  isDroppable: function(other) {
    return !this._equals(other) && !this._hasAncestor(other);
  },
  modelId: function() {
    var areaId = this._area.attr('id');
    return areaId.match(new RegExp('^shrink_' + this.name() + '_(\\d*)'))[1];
  },
  area: function() {
    return this._area;
  },
  _equals: function(other) {
    return this.name() == other.name() && this.modelId() == other.modelId();
  },
  _hasAncestor: function(other) {
    return this._area.parents().index(other.area()) >= 0;
  }
});

var _UnorderedList = $.klass({
  elementPosition: function(elementSelector) {
    return $(elementSelector).positionInParent();
  }
});
var UnorderedList = new _UnorderedList();

var Table = $.klass({
  initialize: function(tableSelector) {
    this._table = $(tableSelector);
  },
  row: function(rowPosition) {
    var rowElement = this._table.find('tr')[rowPosition];
    return $(rowElement);
  },
  cell: function(rowPosition, cellPosition) {
    var rowObject = this.row(rowPosition);
    var cellElement = rowObject.find('td, th')[cellPosition];
    return $(cellElement);
  },
  rowPosition: function(rowSelector) {
    return $(rowSelector).positionInParent();
  },
  columnPosition: function(cellSelector) {
    return $(cellSelector).positionInParent();
  },
  numberOfRows: function() {
    return this._table.find('tr').length;
  },
  numberOfColumns: function() {
    return this.row(0).find('th,td').length;
  },
  removeRow: function(rowPosition) {
    this.row(rowPosition).remove();
  },
  removeColumn: function(columnPosition) {
    this._table.find('tr').each(function(i, rowElement) {
      var cellElement = $(rowElement).find('th, td')[columnPosition];
      $(cellElement).remove();
    });
  }
});

var AddFeatureLink = $.klass({
  initialize: function() {
    this._linkObject = $('#add_feature_link');
  },
  configureFormPopup: function() {
    var self = this;
    self._linkObject.colorbox(
      { innerWidth: '775px',
        innerHeight: '180px',
        inline: true,
        href: '#add_feature_form_area',
        onOpen: function() {
          $.ajax({ dataType: 'script',
                   type: 'get',
                   url: '/features/refresh_folder_select'
          });
        },
        onComplete: function() {
          new AddFeatureForm().clear();
        }
      });
  }
});

var Feature = $.klass({
  initialize: function(areaSelector) {
    this._area = $(areaSelector);
  },
  addTag: function(tagName) {
    var tagTextField = this._area.find('.tags_form_area input:visible:enabled:first');
    var tagLine = tagTextField.val();
    if (!this._commaDelimitedStringIncludesElement(tagLine, tagName)) {
      var appendString = tagName;
      if (tagLine.replace(/\s*/g, '').length > 0) {
        appendString = ', ' + appendString
      }
      tagTextField.val(tagLine + appendString);
    }
  },
  toggle: function() {
    this._expandArea().toggle('blind', null, 500);
  },
  remove: function() {
    this._area.fadeOutAndRemove();
    this._folderFeatureArea().fadeOutAndRemove();
  },
  _commaDelimitedStringIncludesElement: function(commaDelimitedString, element) {
    var commaDelimitedStringWithConsistentCommaSpacing = commaDelimitedString.replace(/\s*,\s*/g, ',');
    var elementMatchRegularExpression = new RegExp('(^|,)' + element + '(,|$)');
    return commaDelimitedStringWithConsistentCommaSpacing.match(elementMatchRegularExpression) != null;
  },
  _expandArea: function() {
    return this._area.find('.detail:first');
  },
  _folderFeatureArea: function() {
    return $('#shrink_feature_' + this._modelId(this._area) + '_folder_link_area');
  },
  _modelId: function() {
    return this._area.attr('id').match(/^area_shrink_feature_(.*)$/)[1];
  }
});

var _Folders = $.klass({
  expandAll: function() {
    this._onRootDescendantFolderObjects(function(object) {
      object.expand();
    });
  },
  collapseAll: function() {
    this._onRootDescendantFolderObjects(function(object) {
      object.collapse();
    });
  },
  makeDragAndDroppable: function(railsMandatoryParameters) {
    this._makeDraggable();
    this._makeDroppable(railsMandatoryParameters);
  },
  _onRootDescendantFolderObjects: function(callback) {
    $('#folders li').each(function(i, object) {
       callback(new Folder(object));
    });
  },
  _makeDraggable: function() {
    $('#folders .edit_folder_link').makeDraggableWithin("#folders .root_folder", function(draggedDomElement) {
      draggedDomElement.modelObject = new Folder($(draggedDomElement).closest('li'));
    });
  },
  _makeDroppable: function(railsMandatoryParameters) {
    $('#folders .header').droppable({
      accept: '.edit_folder_link, .folder_feature_link',
      drop: function(event, ui) {
        var draggedModelObject = ui.draggable.get(0).modelObject;
        var destinationModelObject = new Folder($(this));
        if (destinationModelObject.isDroppable(draggedModelObject)) {
          draggedModelObject.area().fadeOut('fast');
          $.ajax({ data: 'source_id=' + draggedModelObject.modelId() +
                         '&destination_id=' + destinationModelObject.modelId() + '&' + railsMandatoryParameters,
                   dataType: 'script',
                   type: 'post',
                   url: '/folders/move_' + draggedModelObject.name()
          });
        }
      }
    });
  }
});
var Folders = new _Folders();

var Folder = $.klass(ModelObject, {
  initialize: function($super, areaSelector) {
    $super(areaSelector);
    this._expandCollapseLink = this._area.find('.folder_expand_collapse_link');
    this._expandArea = this._area.find('.expand_area');
  },
  toggle: function() {
    if (this._expandCollapseLink.attr('title') == 'Expand') {
      this.expand();
    } else {
      this.collapse();
    }
  },
  expand: function() {
    this._expandArea.fadeIn('fast');
    this._expandCollapseLink.attr('title', 'Collapse');
  },
  collapse: function() {
    this._expandArea.fadeOut('fast');
    this._expandCollapseLink.attr('title', 'Expand');
  },
  name: function() {
    return "folder";
  }
});

var _FolderFeatures = $.klass({
  makeDraggable: function() {
    $('#folders .folder_feature_link').makeDraggableWithin("#folders .root_folder", function(draggedDomElement) {
      draggedDomElement.modelObject = new FolderFeature($(draggedDomElement).closest('li'));
    });
  }
});
var FolderFeatures = new _FolderFeatures();

var FolderFeature = $.klass(ModelObject, {
  initialize: function($super, areaSelector) {
    $super($(areaSelector));
  },
  name: function() {
    return "feature";
  }
});

var FolderImportLink = $.klass({
  initialize: function(linkObject) {
    this._folderId = linkObject.attr('id').match(new RegExp('shrink_folder_(\\d*)$'))[1];
    this._showFormLink = $('#folder_import_form_show_link');
  },
  openFormPopup: function() {
    $('#folder_import_folder_id').val(this._folderId);
    this._showFormLink.click();
  }
});

var SearchResults = $.klass({
  initialize: function() {
    this._results = $('#search_results');
    this._viewPreviousResults = $('#search_results_view_previous');
  },
  open: function() {
    this.reopen();
  },
  reopen: function() {
    this._viewPreviousResults.hide();
    this._results.show('blind', null, 500);
  },
  processPageClick: function(event) {
    $.ajax({ dataType: 'script', type: 'get', url: event.target.href });
    event.preventDefault();
  },
  close: function() {
    var self = this;
    if (self._results.is(':visible')) {
      self._results.hide('blind', null, 500, function() {
        self._viewPreviousResults.show('blind', null, 500);
      })
    }
  }
});
