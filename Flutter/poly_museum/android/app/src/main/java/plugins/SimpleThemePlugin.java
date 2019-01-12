package plugins;

import polytech.al.imh.polymuseum.ExtensionPoint;

public class SimpleThemePlugin extends ThemePlugin {

    public SimpleThemePlugin(ExtensionPoint extensionPoint) {
        super(extensionPoint);
    }

    @Override
    public int getPrimaryColor() {
        return 0;
    }

    @Override
    public int getSecondaryColor() {
        return 0;
    }

    @Override
    public int getBackground() {
        return 0;
    }

    @Override
    public boolean isDarkTheme() {
        return false;
    }

}
