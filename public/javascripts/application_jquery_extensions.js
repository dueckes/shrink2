jQuery.fn.extend({
  fadeOutAndRemove: function(speed) {
    return this.fadeOut(speed, function() {
      jQuery(this).remove();
    });
  },
  fadeOutAndBlank: function(speed) {
    return this.fadeOut(speed, function() {
      jQuery(this).html('');
    });
  },
  hideAndBlank: function() {
    this.hide();
    return this.html('');
  }
});
