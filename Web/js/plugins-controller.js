function PluginsController(block) {
    this.block = block;
    this.database = firebase.firestore();
    this.plugins = {};
}

PluginsController.prototype.init = function() {
    this.fetchData();
}

PluginsController.prototype.fetchData = function() {
    var plugins = this.plugins;
    var block = this.block;
    
    this.database
	.collection("Plugins")
	.get()
	.then(function(querySnapshot) {

    	    querySnapshot.forEach(function(document) {
		var data = document.data()
		var plugin =  {
		    "name" : data.name,
		    "activated" : data.activated
		};

		plugins[document.id] = plugin;

		var text = plugin.name;
		text += (plugin.activated)? ' activé' : ' désactivé';
		
		var listElement = $('<li>');
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
			.attr('checked', true)
		}
		
		block.append(listElement);
	    });
	});
}

$(document).ready(function() {
    $('ul#plugins-list').each(function() {
	new PluginsController($(this)).init();
    });
});
