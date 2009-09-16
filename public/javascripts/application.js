// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function menutoggle(id) {
	menuObject =  $(id);

	if (menuObject.className.indexOf("current") == -1) {
		menuObject.className = "current";
	} else {
		menuObject.className = "";
	}
}

function showImportForm() {
	Effect.toggle("importform", "blind");	
	menutoggle("menu-import");
}
