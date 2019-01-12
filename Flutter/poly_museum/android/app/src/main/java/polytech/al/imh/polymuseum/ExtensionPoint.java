package polytech.al.imh.polymuseum;

import java.util.ArrayList;
import java.util.List;

import plugins.Plugin;

public abstract class ExtensionPoint{

    private List<Plugin> plugins = new ArrayList<>();

    public void registerAsPlugin(Plugin plugin) {
        plugins.add(plugin);
    }

    public List<Plugin> registeredPlugins() {
        return plugins;
    }
}
