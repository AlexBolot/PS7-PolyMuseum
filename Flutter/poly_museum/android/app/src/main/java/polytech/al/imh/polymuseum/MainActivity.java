package polytech.al.imh.polymuseum;

import android.os.Bundle;

import java.io.File;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import plugins.Plugin.PluginType;
import plugins.ThemePlugin;

@SuppressWarnings("ConstantConditions")
public class MainActivity extends FlutterActivity {
    private static final String PLUGIN_CHANNEL = "channel:polytech.al.imh/plugin";
    private static ThemeExtensionPoint themeExtensionPoint = new ThemeExtensionPoint();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(this.getFlutterView(), PLUGIN_CHANNEL).setMethodCallHandler((methodCall, result) -> {

            switch (methodCall.method) {
                case "loadPlugins":

                    List<String> paths = methodCall.argument("paths");
                    List<String> types = methodCall.argument("types");
                    List<String> packageNames = methodCall.argument("packageNames");

                    if (paths.size() != types.size() || paths.size() != packageNames.size()) {
                        throw new IllegalArgumentException("Incoherent data given for plugins");
                    }


                    System.out.println(">> Start loading plugins");

                    loadPlugins(paths, types, packageNames);

                    System.out.println(">> Finished loading plugins");

                    break;

                //-----------------------------------------------------------------------//

                case "processThemePlugins":
                    result.success(themeExtensionPoint.processPlugins());


            }
        });
    }

    private void loadPlugins(List<String> paths, List<String> types, List<String> packageNames) {

        System.out.println(">> " + paths.size() + " plugins to load");

        for (int i = 0; i < paths.size(); i++) {

            System.out.println(paths.get(i) + " - " + types.get(i) + " - " + packageNames.get(i));

            switch (PluginType.valueOf(types.get(i))) {
                case THEME_PLUGIN:
                    loadThemePlugin(paths.get(i), packageNames.get(i));
            }
        }
    }

    private void loadThemePlugin(String pluginPath, String packageName) {
        try {
            File file = new File(pluginPath);
            ClassLoader classLoader = MainActivity.this.getClass().getClassLoader();
            URLClassLoader urlClassLoader = new URLClassLoader(new URL[]{file.toURI().toURL()}, classLoader);

            Class loadedClass = Class.forName(packageName, true, urlClassLoader);

            ThemePlugin themePlugin = (ThemePlugin) loadedClass.newInstance();
            themePlugin.plugTo(themeExtensionPoint);

        } catch (Exception exception) {
            System.out.println("--- Error occurred while trying to load THEME_PLUGIN : SimpleThemePlugin.class");
            System.out.println(exception.getMessage());
            System.out.println("-----------------------------------------------------------");
        }
    }
}
