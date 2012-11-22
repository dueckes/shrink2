var _InlineEdit = $.klass({
  update: function(selector, html) {
    new EditForm(selector).close();
    var element = $(selector);
    element.html(html);
    element.fadeIn('fast');
  },
  edit: function(selector, html) {
    var element = $(selector);
    element.hide();
    element.html(html);
    new EditForm(selector).open();
  }
});
var InlineEdit = new _InlineEdit();
