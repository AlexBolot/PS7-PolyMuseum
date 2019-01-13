package plugins;

import polytech.al.imh.polymuseum.ThemeExtensionPoint;

public abstract class ThemePlugin extends Plugin {

    protected ThemeExtensionPoint themeExtensionPoint;

    public void plugTo(ThemeExtensionPoint themeExtensionPoint){
        this.themeExtensionPoint = themeExtensionPoint;
        this.themeExtensionPoint.registerAsPlugin(this);
    }

    public abstract int getPrimaryColor();

    public abstract int getSecondaryColor();

    public abstract int getBackground();

    public abstract boolean isDarkTheme();
}
