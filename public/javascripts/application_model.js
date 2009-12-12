var Feature = $.klass({
  initialize: function(areaSelector) {
    this._area = $(areaSelector);
    this._detailArea = $(areaSelector).find(".detail:first");
  },
  addTag: function(tagName) {
    var tagTextField = this._area.find(".tags_form_area input:visible:enabled:first");
    var tagLine = tagTextField.val();
    if (!this._commaDelimitedStringIncludesElement(tagLine, tagName)) {
      var appendString = tagName;
      if (tagLine.replace(/\s*/g, "").length > 0) {
        appendString = ", " + appendString
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
    var commaDelimitedStringWithConsistentCommaSpacing = commaDelimitedString.replace(/\s*,\s*/g, ",");
    var elementMatchRegularExpression = new RegExp("(^" + element + ",)|(," + element + ",)|(," + element + "$)");
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
  _onRootDescendantFolderObjects : function(callback) {
    $('#folders_area li').each(function(i, object) {
       callback(new Folder(object));
    });
  }
});
var Folders = new _Folders();

var Folder = $.klass({
  initialize: function(objectSelector) {
    var object = $(objectSelector);
    this._expandCollapseLink = object.find(".folder_expand_collapse_link");
    this._expandArea = object.find(".expand_area");
  },
  toggle: function() {
    if (this._expandCollapseLink.attr('title') == 'Expand') {
      this.expand();
    } else {
      this.collapse();
    }
  },
  expand : function() {
    this._expandArea.fadeIn('fast');
    this._expandCollapseLink.attr('title', 'Collapse');
  },
  collapse : function() {
    this._expandArea.fadeOut('fast');
    this._expandCollapseLink.attr('title', 'Expand');
  }
});
