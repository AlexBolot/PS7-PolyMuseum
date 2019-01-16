var pluginController = undefined;
var importPluginController = undefined;

$(document).ready(function() {
    console.log($('ul#plugins-list'));

    $('ul#plugins-list').each(function() {
	pluginsController = new PluginsController($(this));
	pluginsController.init();

	$('div#import-plugin-div').each(function() {
	    importPluginController = new ImportPluginController($(this), pluginsController);
	    importPluginController.init();
	});
    });
});
