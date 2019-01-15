function ImportPluginController(block) {
    this.block = block;
    this.database = firebase.firestore();
    this.form = block.find('form');
}

ImportPluginController.prototype.init = function() {
    var self = this;
    
    this.form.find('button').click(function() {
	var formData = new FormData(self.form[0]);
	self.uploadPlugin(formData);
    });
}

ImportPluginController.prototype.uploadPlugin = function(formData) {
    $.ajax({
	type : 'POST',
	url : '/ajax/upload-plugin',
	data : formData,
	contentType : false,
	cache : false,
	processData : false,
	success : function(response) {
	    console.log(response);
	},
	error : function(error) {
	    console.log(error);	    
	}
    });
}

$(document).ready(function() {
    $('div#import-plugin-div').each(function() {
	new ImportPluginController($(this)).init();
    });
});
