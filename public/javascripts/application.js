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
	Effect.toggle(id, "blind");
	toggleStyle(id);
}

function menuToggle(id) {
	menuObject =  $(id);

	if (menuObject.className.indexOf("current") == -1) {
		menuObject.className = "current";
	} else {
		menuObject.className = "";
	}
}

function showImportForm() {
	Effect.toggle("importform", "blind");
	menuToggle("menu-import");
}

function commaDelimitedStringIncludesElement(commaDelimitedString, element) {
  var commaDelimitedStringWithConsistentCommaSpacing = commaDelimitedString.gsub(/\s*,\s*/, ",");
  var elementMatchRegularExpression = new RegExp("(^" + element + ",)|(," + element + ",)|(," + element + "$)");
  return commaDelimitedStringWithConsistentCommaSpacing.match(elementMatchRegularExpression) != null;
}

function addTag(tagLineTextFieldId, tagName) {
  var tagLine = $(tagLineTextFieldId).value;
  if (!commaDelimitedStringIncludesElement(tagLine, tagName)) {
    var appendString = tagName;
    if (!tagLine.blank()) {
      appendString = ", " + appendString
    }
    $(tagLineTextFieldId).value = tagLine + appendString;
  }
}
