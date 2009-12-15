var ModelObject = $.klass({
  initialize: function(areaSelector) {
    this._area = $(areaSelector);
  },
  equals:function (other) {
    return this.name() == other.name() && this.modelId() == other.modelId();
  },
  modelId: function() {
    var areaId = this._area.attr('id');
    return areaId.match(new RegExp('^platter_' + this.name() + '_(\\d*)'))[1];
  },
  area: function() {
    return this._area;
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
    this._detailArea().toggle('blind', null, 500);
  },
  remove: function() {
    this._area.fadeOutAndRemove();
    this._folderFeatureArea().fadeOutAndRemove();
  },
  _commaDelimitedStringIncludesElement: function(commaDelimitedString, element) {
    var commaDelimitedStringWithConsistentCommaSpacing = commaDelimitedString.replace(/\s*,\s*/g, ',');
    var elementMatchRegularExpression = new RegExp('(^' + element + ',)|(,' + element + ',)|(,' + element + '$)');
    return commaDelimitedStringWithConsistentCommaSpacing.match(elementMatchRegularExpression) != null;
  },
  _detailArea: function() {
    return this._area.find('.detail:first');
  },
  _folderFeatureArea: function() {
    return $('#platter_feature_' + this._modelId(this._area) + '_folder_link_area');
  },
  _modelId: function() {
    return this._area.attr('id').match(/^area_platter_feature_(.*)$/)[1];
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
      draggedDomElement.modelObject = new Folder($(draggedDomElement).closest('li'));
    });
  },
  _makeDroppable: function(rails_mandatory_parameters) {
    $('#folders_area .header').droppable({
      accept: '.edit_folder_link, .folder_feature_link',
      drop: function(event, ui) {
        var draggedModelObject = ui.draggable.get(0).modelObject;
        var destinationModelObject = new Folder($(this));
        if (!draggedModelObject.equals(destinationModelObject)) {
          draggedModelObject.area().fadeOut('fast');
          $.ajax({ data: 'source_id=' + draggedModelObject.modelId() +
                         '&destination_id=' + destinationModelObject.modelId() + rails_mandatory_parameters,
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
    $('#folders_area .folder_feature_link').makeDraggable("#folders_area .root_folder", function(draggedDomElement) {
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
