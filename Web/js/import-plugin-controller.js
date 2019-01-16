function ImportPluginController(block, pluginsController) {
    this.block = block;
    this.database = firebase.firestore();
    this.form = block.find('form');
    this.pluginsController = pluginsController;
}

ImportPluginController.prototype.init = function() {
    var self = this;
    
    this.form.find('button').click(function() {
	var formData = new FormData(self.form[0]);
	self.uploadPlugin(formData);
    });
}

ImportPluginController.prototype.uploadPlugin = function(formData) {
    var self = this;
    
    $.ajax({
	type : 'POST',
	url : '/ajax/upload-plugin',
	data : formData,
	contentType : false,
	cache : false,
	processData : false,
	success : function(response) {
	    self.pluginsController.reloadPlugins();
	},
	error : function(error) {
	    console.log(error);	    
	}
    });
}

