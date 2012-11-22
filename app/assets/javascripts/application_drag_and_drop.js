var _DragAndDrop = $.klass({
 show_move: function(callback) {
   // setTimeout addresses jQuery defect when removing dropped element - see http://dev.jqueryui.com/ticket/4550
   setTimeout(function() {
     callback();
   }, 500);
 }
});
var DragAndDrop = new _DragAndDrop();
