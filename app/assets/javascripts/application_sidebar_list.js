var _SidebarList = $.klass({
  update: function(id, content) {
    $('#' + id).fadeOutAndIn(function() {
      $('#' + id + 'show_link').html(content);
    })
  }
});
var SidebarList = new _SidebarList();
