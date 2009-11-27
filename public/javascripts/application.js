// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function toggleStyle(id) {
	titleObj = id + "-title";

	titleObject = $(titleObj);
	if (titleObject.className.indexOf("current") == -1) {
		titleObject.className = "current";
	} else {
		titleObject.className = "";
	}
}

function toggle(id) {
	$(id).toggle("blind");
	toggleStyle(id);
}

function menuToggle(id) {
	menuObject = $(id);

	if (menuObject.className.indexOf("current") == -1) {
		menuObject.className = "current";
	} else {
		menuObject.className = "";
	}
}

function commaDelimitedStringIncludesElement(commaDelimitedString, element) {
  var commaDelimitedStringWithConsistentCommaSpacing = commaDelimitedString.replace(/\s*,\s*/g, ",");
  var elementMatchRegularExpression = new RegExp("(^" + element + ",)|(," + element + ",)|(," + element + "$)");
  return commaDelimitedStringWithConsistentCommaSpacing.match(elementMatchRegularExpression) != null;
}

function addTag(tagLineTextFieldMatcher, tagName) {
  var tagLine = $(tagLineTextFieldMatcher).val();
  if (!commaDelimitedStringIncludesElement(tagLine, tagName)) {
    var appendString = tagName;
    if (tagLine.replace(/\s*/g, "").length > 0) {
      appendString = ", " + appendString
    }
    $(tagLineTextFieldMatcher).val(tagLine + appendString);
  }
}
