//TODO Eliminate propogation of speed: 'fast'
jQuery.fn.extend({
  fadeOutAndRemove: function() {
    return this.fadeOut('fast', function() {
      jQuery(this).remove();
    });
  },
  fadeOutAndBlank: function(speed) {
    return this.fadeOut(speed, function() {
      jQuery(this).html('');
    });
  },
  fadeOutAndIn: function(callback) {
    return this.fadeOut('fast', function() {
      callback(jQuery(this));
      jQuery(this).fadeIn('fast');
    });
  },
  hideAndBlank: function() {
    this.hide();
    return this.html('');
  },
  makeDraggable: function(containment, startCallback) {
    this.draggable({
      containment: containment,
      revert: true,
      start: function(event, ui) {
        this.dragged = true;
        if (startCallback) {
          startCallback(this);
        }
      }
    });
  }
});
