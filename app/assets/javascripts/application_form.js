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
    var callback = function() { self.focus(); };
    if (effect == 'blind') {
      self._form.show('blind', null, 500, callback);
    } else {
      self._form.fadeIn('fast', callback);
    }
  },
  toggle: function() {
    if (this._form.is(':visible')) {
      this.close();
    }
    else {
      this.open();
    }
  },
  cancel: function() {
    this.close();
  },
  clear: function() {
    this._clearInputValues();
    this._uncheckRadioButtons();
    this._clearErrors();
    this.focus();
  },
  focus: function() {
    this.firstInput().focus();
  },
  firstInput: function() {
    return this._form.find('input:visible:enabled:first');
  },
  _clearInputValues: function() {
    this._form.find('input:enabled, select:enabled')
            .not('*[type=hidden]')
            .not('*[type=button]')
            .not('*[type=submit]')
            .not('*[type=radio]')
            .each(function(i, input) {
      var inputObject = $(input);
      inputObject.val('');
      if (inputObject.flushCache != null) {
        inputObject.flushCache();
      }
    });
  },
  _uncheckRadioButtons: function() {
    this._form.find('input:visible:enabled[type=radio]').each(function(i, input) {
      $(input).attr('checked', false);
    });
  },
  _clearErrors: function() {
    this._form.find('div[id*=errors]').each(function(i, element) {
      $(element).hideAndBlank();
    });
  }
});

var PopUpForm = $.klass(StandardForm, {
  initialize: function($super, formName, popUpWidth, popUpHeight) {
    $super('#' + formName + '_form');
    this._link = $('#' + this._form.attr('id') + '_show_link');
    this._targetDivId = this._form.closest('div').attr('id');
    this._popUpWidth = popUpWidth;
    this._popUpHeight = popUpHeight;
  },
  configurePopup: function() {
    var self = this;
    self._link.colorbox(
      { innerWidth: self._popUpWidth,
        innerHeight: self._popUpHeight,
        inline: true,
        href: '#' + self._targetDivId,
        onComplete: function() {
          self.clear();
        }
      });
  },
  close: function() {
    $.fn.colorbox.close();
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
  setContainerDomIdAndPositionField: function() {
    this._form.find('input[name=container_dom_id]').val(this._containerDomId());
    this._form.find('input[name*=position]').val(this._positionInList());
  },
  showModelAndClearForm: function() {
    this.clear();
    this._showModel();
  },
  showModelAndRemoveForm: function() {
    this._removeForm();
    this._showModel();
  },
  close: function() {
    var self = this;
    self._form.fadeOut('fast', function() {
      self._removeForm();
    });
  },
  _containerDomId: function() {
    return this._form.closest('li').attr('id');
  },
  _positionInList: function() {
    return UnorderedList.elementPosition(this._form.closest('li'));
  },
  _showModel: function() {
    this._newModel.fadeIn('fast');
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
    this._form.find('input[name=cancel]').val('true');
    this._form.find('input[type=submit]').click();
  }
});

var TagForm = $.klass(StandardForm, {
  initialize: function($super, tagAreaSelector) {
    var tagAreaObject = $(tagAreaSelector);
    $super(tagAreaObject.find('div[id$=_tags_form_area]'));
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

var FolderImportForm = $.klass(PopUpForm, {
  initialize: function($super) {
    $super('folder_import', '750px', '90px');
  }
});

var ProjectAddForm = $.klass(PopUpForm, {
  initialize: function($super) {
    $super('project_add', '750px', '110px');
  }
});

var UserAddForm = $.klass(PopUpForm, {
  initialize: function($super) {
    $super('user_add', '800px', '300px');
  }
});

var UserEditRoleForm = $.klass(PopUpForm, {
  initialize: function($super) {
    $super('user_edit_role', '750px', '120px');
  },
  clear: function() {
    this._clearErrors();
    this.focus();
  }
});

var UserEditPasswordForm = $.klass(PopUpForm, {
  initialize: function($super) {
    $super('user_edit_password', '750px', '120px');
  }
});

var TableForm = $.klass({
  initialize: function(formSelector) {
    this._form = $(formSelector);
    this._table = new Table(formSelector);
  },
  setRowAndColumnNumberFields: function() {
    this._form.find('input[name=number_of_rows]').val(this._table.numberOfRows());
    this._form.find('input[name=number_of_columns]').val(this._table.numberOfColumns());
  }
});

var AddFeatureForm = $.klass({
  initialize: function() {
    this._typeSelectionForm = new StandardForm('#feature_add_type_form');
    this._addForm = new StandardForm('#add_feature_form');
    this._importForm = new StandardForm('#import_feature_form');
  },
  showFormArea: function(formType) {
    $('#' + this._otherFormType(formType) + '_feature_form').hide();
    $('#' + formType + '_feature_form').show();
  },
  clear: function() {
    this._typeSelectionForm.clear();
    this._addForm.clear();
    this._importForm.clear();
    this._selectFirstType();
    this._typeSelectionForm.focus();
  },
  _otherFormType: function(formType) {
    var otherFormType = "add";
    if (formType == otherFormType) {
      otherFormType = "import";
    }
    return otherFormType;
  },
  _selectFirstType: function() {
    this._typeSelectionForm.firstInput().attr('checked', true);
  }
});

var SignInAjaxForm = $.klass(StandardForm, {
  initialize: function($super) {
    $super('#sign_in_ajax_form');
  },
  open: function($super) {
    $super('blind');
  },
  close: function() {
    var self = this;
    self._form.hide('blind', null, 500, function() {
      self.clear();
    });
  }
});

var _FormFactory = $.klass({
  createFromEvent: function(event) {
    var formObject = new NullForm();
    var targetElement = $(event.target);
    var formElement = targetElement.closest('form');
    if (formElement.hasClass('new')) {
      formObject = new AddSimpleForm(formElement.closest('li'), this._clickedAddLinkSelector(formElement));
    } else if (formElement.hasClass('add_anywhere')) {
      formObject = new AddAnywhereForm(formElement.closest('li'));
    } else if (formElement.hasClass('edit')) {
      formObject = new EditForm(formElement);
    } else if (formElement.attr('id') == 'sign_in_ajax_form') {
      formObject = new SignInAjaxForm();
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
