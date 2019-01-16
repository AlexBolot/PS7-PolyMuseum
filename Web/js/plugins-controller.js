function PluginsController(block) {
    this.block = block;
    this.database = firebase.firestore();
    this.plugins = [];
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
	    var index = 0;
	    
    	    querySnapshot.forEach(function(document) {
		var data = document.data()
		var plugin =  {
		    "index" : index++,
		    "id" : document.id,
		    "name" : data.libelle,
		    "requires_config" : data.config,
		    "activated" : ('activated' in data)? data.activated : false
		};

		self.plugins[plugin.id] = plugin;
		
		self.createListElement(plugin);
	    });

	    console.log(self.plugins);
	    self.database
		.collection("Musées/NiceSport/plugins")
		.get()
		.then(function(querySnapshot) {
		    querySnapshot.forEach(function(document) {
			var data = document.data()

			if (data.ref in self.plugins && data.activated) {
			    var index = self.plugins[data.ref].index;
			    self.plugins[data.ref].activated = true;
			    self.block
				.find('input#plugin-' + index + '-cb')
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
    	.attr('id', 'plugin-' + plugin.index + '-le')
	.attr('class', 'plugin-list-element');

    var self = this;
    var checkbox = $('<input>')
	.attr('id', 'plugin-' + plugin.index + '-cb')
	.attr('type', 'checkbox')
	.on('change', function() {
	    activated = false;

	    if ($(this).prop('checked')) {
		activated = true;
	    }
	    
	    self.updatePluginState(plugin, activated);
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
		var musee = $('meta[name=musee]').attr('content');
		self.uploadConfig(formData, musee, plugin.id);
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

PluginsController.prototype.updatePluginState = function(plugin, value) {
    this.database
	.collection("Musées/NiceSport/plugins")
	.doc(plugin.id)
	.set({"activated" : value,
	      "ref" : plugin.id });
}

PluginsController.prototype.uploadConfig = function(formData, musee, plugin) {
    $.ajax({
	type : 'POST',
	url : '/ajax/upload?musee=' + musee + '&plugin=' + plugin,
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
