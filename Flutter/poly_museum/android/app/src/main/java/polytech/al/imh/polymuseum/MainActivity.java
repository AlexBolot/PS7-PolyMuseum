package polytech.al.imh.polymuseum;

import android.os.Bundle;

import com.sdk.makers.ThemeExtensionPoint;
import com.sdk.makers.ThemePlugin;

import java.io.File;
import java.util.List;

import dalvik.system.DexClassLoader;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static com.sdk.makers.Plugin.PluginType;

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
                    List<String> qualifiedNames = methodCall.argument("qualifiedClassNames");
                    List<String> pluginNames = methodCall.argument("pluginNames");

                    if (paths.size() != types.size()
                            || paths.size() != qualifiedNames.size()
                            || paths.size() != pluginNames.size()) {
                        throw new IllegalArgumentException("Incoherent data given for plugins");
                    }

                    System.out.println(">> Start loading plugins");

                    loadPlugins(paths, types, qualifiedNames, pluginNames);

                    System.out.println(">> Finished loading plugins");

                    result.success(null);

                    break;

                //-----------------------------------------------------------------------//

                case "processThemePlugins":

                    System.out.println(">> Processing Theme Plugins");

                    result.success(themeExtensionPoint.processPlugins());
            }
        });
    }

    private void loadPlugins(List<String> paths, List<String> types, List<String> qualifiedNames, List<String> pluginNames) {

        System.out.println(">> " + paths.size() + " plugins to load");

        for (int i = 0; i < paths.size(); i++) {

            System.out.println(paths.get(i) + " - " + types.get(i) + " - " + qualifiedNames.get(i));

            switch (PluginType.valueOf(types.get(i))) {
                case THEME_PLUGIN:
                    loadThemePlugin(paths.get(i), qualifiedNames.get(i), pluginNames.get(i));
            }
        }
    }

    private void loadThemePlugin(String pluginPath, String qualifiedName, String pluginName) {
        try {
            File file = new File(pluginPath);

            DexClassLoader loader = new DexClassLoader(file.getPath(), getFilesDir().getPath(), null, this.getClassLoader());
            Class loadedClass = Class.forName(qualifiedName, true, loader);

            ThemePlugin themePlugin = (ThemePlugin) loadedClass.newInstance();
            themePlugin.plugTo(themeExtensionPoint);

        } catch (Exception exception) {
            System.out.println("--- Error occurred while trying to load THEME_PLUGIN : " + pluginName);
            exception.printStackTrace();
            System.out.println("-----------------------------------------------------------");
        }
    }
}
