var ModelArea = $.klass({
  initialize: function(areaSelector, idPrefix) {
    this._area = $(areaSelector);
    this._idPrefix = idPrefix;
  },
  modelId: function() {
    var areaId = this._area.attr('id');
    return areaId.match(new RegExp('^' + this._idPrefix + '(\\d*)'))[1];
  },
  object: function() {
    return this._area;
  }
});

var Feature = $.klass({
  initialize: function(areaSelector) {
    this._area = $(areaSelector);
    this._detailArea = $(areaSelector).find('.detail:first');
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
    this._detailArea.toggle('blind', null, 500);
  },
  remove: function() {
    this._area.fadeOutAndRemove();
  },
  _commaDelimitedStringIncludesElement: function(commaDelimitedString, element) {
    var commaDelimitedStringWithConsistentCommaSpacing = commaDelimitedString.replace(/\s*,\s*/g, ',');
    var elementMatchRegularExpression = new RegExp('(^' + element + ',)|(,' + element + ',)|(,' + element + '$)');
    return commaDelimitedStringWithConsistentCommaSpacing.match(elementMatchRegularExpression) != null;
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
  makeDragAndDroppable: function(rails_mandatory_parameters) {
    this._makeDraggable();
    this._makeDroppable(rails_mandatory_parameters);
  },
  _onRootDescendantFolderObjects: function(callback) {
    $('#folders_area li').each(function(i, object) {
       callback(new Folder(object));
    });
  },
  _makeDraggable: function() {
    $('#folders_area .edit_folder_link').makeDraggable("#folders_area .root_folder", function(draggedDomElement) {
      draggedDomElement.moveAction = 'move_folder';
      draggedDomElement.sourceIdValue = new Folder($(draggedDomElement).closest('li')).modelId();
    });
  },
  _makeDroppable: function(rails_mandatory_parameters) {
    $('#folders_area .header').droppable({
      accept: '.edit_folder_link, .folder_feature_link',
      drop: function(event, ui) {
        var draggedDomElement = ui.draggable.get(0);
        $.ajax({ data: 'source_id=' + draggedDomElement.sourceIdValue + '&destination_id=' + new Folder($(this)).modelId() + rails_mandatory_parameters,
                 dataType: 'script',
                 type: 'post',
                 url: '/folders/' + draggedDomElement.moveAction});
      }
    });
  }
});
var Folders = new _Folders();

var Folder = $.klass({
  initialize: function(areaSelector) {
    this._modelArea = new ModelArea(areaSelector, 'platter_folder_');
    this._expandCollapseLink = this._modelArea.object().find('.folder_expand_collapse_link');
    this._expandArea = this._modelArea.object().find('.expand_area');
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
  modelId: function() {
    return this._modelArea.modelId();
  }
});

var _FolderFeatures = $.klass({
  makeDraggable: function() {
    $('#folders_area .folder_feature_link').makeDraggable("#folders_area .root_folder", function(draggedDomElement) {
      draggedDomElement.moveAction = 'move_feature';
      draggedDomElement.sourceIdValue = new FolderFeature($(draggedDomElement).closest('li')).modelId();
    });
  }
});
var FolderFeatures = new _FolderFeatures();

var FolderFeature = $.klass({
  initialize: function(areaSelector) {
    this._modelArea = new ModelArea($(areaSelector), 'platter_feature_');
  },
  modelId: function() {
    return this._modelArea.modelId();
  }
});
