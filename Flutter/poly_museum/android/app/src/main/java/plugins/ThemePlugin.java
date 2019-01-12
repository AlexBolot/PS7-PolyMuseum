package plugins;

import polytech.al.imh.polymuseum.ExtensionPoint;

public abstract class ThemePlugin extends Plugin {

    public ThemePlugin(ExtensionPoint extensionPoint) {
        super(extensionPoint);
    }

    public abstract int getPrimaryColor();

    public abstract int getSecondaryColor();

    public abstract int getBackground();

    public abstract boolean isDarkTheme();
}
