package polytech.al.imh.polymuseum;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.Callable;

import plugins.ThemePlugin;

public class ThemeExtensionPoint extends ExtensionPoint {

    private List<ThemePlugin> plugins = new ArrayList<>();
    private HashMap<String, Object> resultOfProcess = new HashMap<>();

    public void registerAsPlugin(ThemePlugin plugin) {
        plugins.add(plugin);
    }

    public HashMap<String, Object> processPlugins() {

        for (ThemePlugin themePlugin : plugins) {
            processMethod(themePlugin::getPrimaryColor, themePlugin.getName(), "getPrimaryColor()");
            processMethod(themePlugin::getSecondaryColor, themePlugin.getName(), "getSecondaryColor()");
            processMethod(themePlugin::getBackground, themePlugin.getName(), "getBackground()");
            processMethod(themePlugin::isDarkTheme, themePlugin.getName(), "isDarkTheme()");
        }

        return resultOfProcess;
    }

    private void processMethod(Callable methodToCall, String pluginName, String methodName) {
        try {
            Object value = methodToCall.call();

            if (resultOfProcess.containsKey(methodName)) {
                System.out.println("> Warning : call to " + methodName + " of " + pluginName + " overriding previous value");
            }

            resultOfProcess.put(methodName, value);

        } catch (Exception exception) {
            handleException(exception, methodName, pluginName);
        }
    }

    private void handleException(Exception exeption, String methodName, String pluginName) {
        System.out.println("--- Error occurred during for " + pluginName + " during call to " + methodName);
        System.out.println(exeption.getMessage());
        System.out.println("-----------------------------------------------------------");
    }
}
