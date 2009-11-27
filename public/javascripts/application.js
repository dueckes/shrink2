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

function commaDelimitedStringIncludesElement(string, element) {
  var stingWithConsistentCommaSpacing = string.replace(/\s*,\s*/g, ",");
  var elementMatchRegularExpression = new RegExp("(^" + element + ",)|(," + element + ",)|(," + element + "$)");
  return stingWithConsistentCommaSpacing.match(elementMatchRegularExpression) != null;
}

function addTag(textFieldId, tagName) {
  if (!commaDelimitedStringIncludesElement($(textFieldId).value, tagName)) {
    $(textFieldId).value = $(textFieldId).value + ", " + tagName;
  }
}
