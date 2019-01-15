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
		    "id" : document.id,
		    "name" : data.libelle,
		    "requires_config" : data.config,
		    "activated" : ('activated' in data)? data.activated : false
		};

		self.plugins[document.id] = plugin;
		
		self.createListElement(plugin);
	    });
	    
	    self.database
		.collection("Musées/NiceSport/plugins")
		.get()
		.then(function(querySnapshot) {
		    querySnapshot.forEach(function(document) {
			if (document.id in self.plugins) {
			    self.plugins[document.id].activated = true;
			    self.block
				.find('input#plugin-' + document.id + '-cb')
				.attr('checked', true)
			}
		    });
		});
	});
}

PluginsController.prototype.createListElement = function(plugin) {
    var text = plugin.name;
    text += (plugin.activated)? ' activé' : ' désactivé';
    
    var listElement = $('<li>')
    	.attr('id', 'plugin-' + plugin.id + '-le')
	.attr('class', 'plugin-list-element');

    var self = this;
    var checkbox = $('<input>')
	.attr('id', 'plugin-' + plugin.id + '-cb')
	.attr('type', 'checkbox')
	.on('change', function() {
	    activated = false;

	    if ($(this).prop('checked')) {
		activated = true;
	    }
	    
	    self.updatePluginState(plugin.id, activated);
	});
    
    listElement
	.append($('<div>')
		.attr('class', 'switch')
		.text(text)
		.prepend($('<label>')
			 .append(checkbox)
			 .append($('<span>')
				 .attr('class', 'lever'))));

    var self = this;
    
    if (plugin.requires_config) {
	var form = $('<form>')
	    .attr('enctype', 'multipart/form-data')
	    .attr('method', 'post')
	    .attr('action', '');

	var label = $('<label>')
	    .attr('for', 'config-file')
	    .text('Select a file')
	
	var input = $('<input>')
	    .attr('class', 'load-config-file')
	    .attr('type', 'file')
	    .attr('name', 'config-file');
	

	var submitBtn = $('<button>')
	    .attr('type', 'button')
	    .text('Envoyer')
	    .click(function() {
		console.log($(this).closest('form')[0]);
		var formData = new FormData($(this).closest('form')[0]);
		self.uploadConfig(formData);
	    });

	
	form.append($('<fieldset>')
		    .append(label)
		    .append(input));
	
	form.append($('<fieldset>')
		    .append(submitBtn));

	listElement.find('div.switch')
	    .append(form);
    }

    this.block.append(listElement);
}

PluginsController.prototype.updatePluginState = function(pluginId, value) {
    this.database
	.collection("Musées/NiceSport/plugins")
	.doc(pluginId)
	.set({"activated" : value });
}

PluginsController.prototype.uploadConfig = function(formData) {
    $.ajax({
	type : 'POST',
	url : '/ajax/upload',
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
    $('ul#plugins-list').each(function() {
	new PluginsController($(this)).init();
    });
});
