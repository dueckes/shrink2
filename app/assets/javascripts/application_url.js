var UrlBuilder = $.klass({
  initialize: function(baseUrl) {
    this.baseUrl = baseUrl;
    this.parameters = $([]);
  },
  addParameter: function(name, value) {
    this.parameters.push([name, value]);
    return this;
  },
  build: function() {
    var completeUrl = this.baseUrl;
    this.parameters.each(function() {
      completeUrl += (completeUrl.indexOf("?") == -1 ? "?" : "&");
      completeUrl += this[0] + "=" + this[1];
    });
    return completeUrl;
  }
});
