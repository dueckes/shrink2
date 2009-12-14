var NullForm = $.klass({
  open: function() {
    // Intentionally do nothing
  },
  close: function() {
    // Intentionally do nothing
  },
  cancel: function() {
    // Intentionally do nothing
  }
});

var StandardForm = $.klass({
  initialize: function(selector) {
    this._form = $(selector);
  },
  open: function(effect) {
    var self = this;
    var callback = function() { self._focus(); };
    if (effect == 'blind') {
      self._form.show('blind', null, 500, callback);
    } else {
      self._form.fadeIn('fast', callback);
    }
  },
  cancel: function() {
    this.close();
  },
  _focus: function() {
    this._form.find('input:visible:enabled:first').focus();
  }
});

var AddSimpleForm = $.klass(StandardForm, {
  initialize: function($super, formAreaSelector, addButtonSelector, newModelSelector) {
    $super(formAreaSelector);
    this._addButton = $(addButtonSelector);
    this._newModel = $(newModelSelector);
  },
  open: function($super) {
    var superMethod = $super;
    this._addButton.fadeOut('fast', function() {
      superMethod('fadeIn');
    });
  },
  close: function() {
    var self = this;
    self._form.fadeOut('fast', function() {
      if (self._newModel != null) {
        self._newModel.fadeIn('fast', function() {
          self._showButton();
        });
      } else {
        self._showButton();
      }
      self._removeForm();
    });
  },
  _showButton: function() {
    if (this._addButton != null) {
      this._addButton.fadeIn('fast');
    }
  },
  _removeForm: function() {
    this._form.html('');
  }
});

var AddAnywhereForm = $.klass(StandardForm, {
  initialize: function($super, formAreaSelector, newModelSelector) {
    $super(formAreaSelector);
    this._newModel = $(newModelSelector);
  },
  setPositionField: function() {
    this._form.find('input[name*=position]').val(this._positionInList());
  },
  showModelAndClearForm: function() {
    this._showModel();
    this._clearForm();
  },
  showModelAndRemoveForm: function() {
    this._showModel();
    this._removeForm();
  },
  close: function() {
    var self = this;
    self._form.fadeOut('fast', function() {
      self._removeForm();
    });
  },
  _positionInList: function() {
    var elementInList = this._form.closest('li');
    var listElements = elementInList.closest('ul').children('li');
    var listElementIds = jQuery.map(listElements, function (listElement) { return $(listElement).attr('id') });
    return $.inArray(elementInList.attr('id'), listElementIds);
  },
  _showModel: function() {
    this._newModel.fadeIn('fast');
  },
  _clearForm: function() {
    this._form.find('input:enabled:visible').each(function(i, inputObject) {
      $(inputObject).val('');
    });
  },
  _removeForm: function() {
    this._form.remove();
  }
});

var EditForm = $.klass(StandardForm, {
  initialize: function($super, selector) {
    $super(selector);
  },
  close: function() {
    this._form.fadeOut('fast');
  },
  cancel: function() {
    this._form.find('input[name=cancel_edit]').val('true');
    this._form.find('input[type=submit]').click();
  }
});

var MenuForm = $.klass({
  initialize: function(menuItemName) {
    this._menuItem = new TopMenuItem(menuItemName);
  },
  open: function() {
    this._menuItem.toggle();
  },
  cancel: function() {
    this._menuItem.hide();
  }
});

var TagForm = $.klass(StandardForm, {
  initialize: function($super, tagAreaSelector) {
    var tagAreaObject = $(tagAreaSelector);
    $super(tagAreaObject.find('div[id$=_tags_form]'));
    this._list = tagAreaObject.find('div[id$=_tags_list]');
    this._text = tagAreaObject.find('div[id$=_tags_text]');
  },
  open: function($super) {
    var superMethod = $super;
    var self = this;
    self._list.fadeOut('fast', function() {
      superMethod('blind');
    });
  },
  close: function() {
    var self = this;
    self._form.hide('blind', null, 500, function() {
      self._list.fadeIn('fast', function() {
        self._form.html('');
      });
    });
  }
});

var _FormFactory = $.klass({
  createFromEvent: function(event) {
    var formObject = new NullForm();
    var targetElement = $(event.target);
    var formElement = targetElement.closest('form');
    if (formElement.closest('#menu').size() > 0) {
      formObject = new MenuForm(formElement.closest('li').attr('id').match(/^menu_(.*)$/)[1]);
    } else if (formElement.hasClass('add')) {
      formObject = new AddSimpleForm(formElement.closest('li'), this._clickedAddLinkSelector(formElement));
    } else if (formElement.hasClass('add_anywhere')) {
      formObject = new AddAnywhereForm(formElement.closest('li'));
    } else if (formElement.hasClass('edit')) {
      formObject = new EditForm(formElement);
    } else if (formElement.closest('.tags_area').size() > 0) {
      formObject = new TagForm(formElement.closest('.tags_area'));
    }
    return formObject;
  },
  _clickedAddLinkSelector: function(formElement) {
    return '#' + formElement.find('input[name=clicked_add_link_id]').val();
  }
}
);
var FormFactory = new _FormFactory();
