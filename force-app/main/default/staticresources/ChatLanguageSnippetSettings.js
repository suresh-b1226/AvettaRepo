window._snapinsSnippetSettingsFile = (function() {
    console.log("Snippet settings file loaded.");	// Logs that the snippet settings file was loaded successfully

    embedded_svc.snippetSettingsFile.directToButtonRouting = function(prechatFormData) {
		
		
		if(prechatFormData[3].value === "French") {
		return "57370000000blJxAAI";
		}
		
		if(prechatFormData[3].value === "Portuguese") {
		return "57370000000blKbAAI";
		}
	}


})();