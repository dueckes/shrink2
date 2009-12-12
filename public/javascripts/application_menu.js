var _TopMenu = $.klass({
  hideOtherItems: function(topMenuItem) {
    $('#menu .expand_area:visible').each(function(i, areaObject) {
      if (areaObject.id != topMenuItem.expandArea().attr('id')) {
        new TopMenuItem(areaObject.id.match(/^menu_(.*)_expand_area/)[1]).hide();
      }
    })
  }
});
var TopMenu = new _TopMenu();

var TopMenuItem = $.klass({
  initialize: function(name) {
    this._name = name;
    this._areaObject = $('#menu_' + name);
    this._expandAreaObject = $('#menu_' + name + '_expand_area');
  },
  toggle: function() {
    var self = this;
    TopMenu.hideOtherItems(self);
    self._expandAreaObject.toggle('blind', null, 500, function() {
      if (self._areaObject.hasClass('expanded')) {
        self._expandAreaObject.find('input:visible:enabled:first').focus();
      }
    });
    self._areaObject.toggleClass('expanded');
  },
  hide: function() {
    var self = this;
    self._expandAreaObject.hide('blind', null, 500, function() {
      self._areaObject.removeClass('expanded');
      self._expandAreaObject.html('');
    });
  },
  expandArea: function() {
    return this._expandAreaObject;
  }
});

var _FoldMenu = $.klass({
  hideAllItems: function() {
    $('#fold_menu .fold_item').each(function(i, itemObject) {
      FoldMenuItemFactory.createFromObject($(itemObject)).hide();
    })
  }
});
var FoldMenu = new _FoldMenu();

var FoldMenuItem = $.klass({
  initialize: function(itemObject) {
    this._itemObject = itemObject;
    this._minimizedWidth = '-421px';
    this._maximizedWidth = '0px';
  },
  toggle: function() {
    var targetWidth = this._maximizedWidth;
    if (this._itemObject.css('left') == this._maximizedWidth) {
      targetWidth = this._minimizedWidth;
    }
    this._itemObject.animate({ left: targetWidth }, 500);
  },
  hide: function() {
    this._itemObject.animate({ left: this._minimizedWidth }, 500);
  }
});

var _FoldMenuItemFactory = $.klass({
  createFromObject: function(object) {
    return new FoldMenuItem(object);
  },
  createFromName: function(itemName) {
    return new FoldMenuItem($('#fold_menu_' + itemName));
  }
});
var FoldMenuItemFactory = new _FoldMenuItemFactory();
