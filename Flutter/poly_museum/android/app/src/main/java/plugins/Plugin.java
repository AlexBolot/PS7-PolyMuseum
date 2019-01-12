package plugins;


import polytech.al.imh.polymuseum.ExtensionPoint;

public abstract class Plugin {

    protected ExtensionPoint extensionPoint;

    public Plugin(ExtensionPoint extensionPoint) {
        this.extensionPoint = extensionPoint;
    }
}
