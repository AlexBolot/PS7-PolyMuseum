function PluginsController(block) {
    this.block = block;
    this.database = firebase.firestore();
    this.plugins = {};
}

PluginsController.prototype.init = function() {
    this.fetchData();
}

PluginsController.prototype.fetchData = function() {
    var self = this;
    
    this.database
	.collection("Plugins")
	.get()
	.then(function(querySnapshot) {

    	    querySnapshot.forEach(function(document) {
		var data = document.data()
		var plugin =  {
		    "name" : data.name,
		    "activated" : data.activated,
		    "config" : data.config
		};

		self.plugins[document.id] = plugin;

		self.createListElement(plugin);
	    });
	});

}

PluginsController.prototype.createListElement = function(plugin) {
    var text = plugin.name;
    text += (plugin.activated)? ' activé' : ' désactivé';
    
    var listElement = $('<li>')
	.attr('class', 'plugin-list-element');
    
    listElement
	.append($('<div>')
		.attr('class', 'switch')
		.text(text)
		.prepend($('<label>')
			 .append($('<input>')
				 .attr('id', 'plugin-' + document.id + '-cb')
				 .attr('type', 'checkbox'))
			 .append($('<span>')
				 .attr('class', 'lever'))));

    if (plugin.activated) {
	listElement.find('input#plugin-' + document.id + '-cb')
	    .attr('type', 'checkbox')
	    .attr('checked', true)
    }

    var self = this;
    
    if (plugin.config) {
	var form = $('<form>')
	    .attr('enctype', 'multipart/form-data')
	    .attr('method', 'post')
	    .attr('action', '')
	    .submit(function(event) {
		event.preventDefault();

		self.uploadConfig(new FormData($(this)[0]));
	    });
		    
	var input = $('<input>')
	    .attr('class', 'load-config-file')
	    .attr('type', 'file')
	    .attr('name', 'config-file');

	var submitBtn = $('<input>')
	    .attr('type', 'submit')
	    .attr('name', 'submit-config-file');
	
	form.append(input);
	form.append(submitBtn);

	listElement.find('div.switch')
	    .append(form);
    }

    this.block.append(listElement);
}

PluginsController.prototype.uploadConfig = function(formData) {
    $.ajax({
	url : window.location.pathname + '/api/upload-config.php',
	data : formData,
	type : 'POST',
	processData: false,
	contentType: false,
	success : function(response) {
	    console.log(response);
	},
	error : function(error) {
	    console.log(error);	    
	}
    });
}

$(document).ready(function() {
    $('ul#plugins-list').each(function() {
	new PluginsController($(this)).init();
    });
});
