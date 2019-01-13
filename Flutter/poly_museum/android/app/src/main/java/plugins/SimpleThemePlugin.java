package plugins;

public class SimpleThemePlugin extends ThemePlugin {

    @Override
    public String getName() {
        return "SimplePluginName";
    }

    @Override
    public int getPrimaryColor() {
        return 0x4286F4;
    }

    @Override
    public int getSecondaryColor() {
        return 0x0044B2;
    }

    @Override
    public int getBackground() {
        return 0xDBD8C7;
    }

    @Override
    public boolean isDarkTheme() {
        return false;
    }

}
