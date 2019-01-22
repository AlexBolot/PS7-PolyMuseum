package polytech.al.imh.polymuseum;

import android.os.Bundle;

import com.sdk.makers.CustomViewExtensionPoint;
import com.sdk.makers.CustomViewPlugin;
import com.sdk.makers.Plugin.PluginType;
import com.sdk.makers.ThemeExtensionPoint;
import com.sdk.makers.ThemePlugin;

import org.json.JSONObject;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dalvik.system.DexClassLoader;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static com.sdk.makers.Plugin.PluginType.THEME_PLUGIN;


@SuppressWarnings("ConstantConditions")
public class MainActivity extends FlutterActivity {
    private static final String PLUGIN_CHANNEL = "channel:polytech.al.imh/plugin";
    private static ThemeExtensionPoint themeExtensionPoint = new ThemeExtensionPoint();
    private static CustomViewExtensionPoint customViewExtensionPoint = new CustomViewExtensionPoint();
    private static Map<PluginType, JSONObject> configs = new HashMap<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(this.getFlutterView(), PLUGIN_CHANNEL).setMethodCallHandler((methodCall, result) -> {

            switch (methodCall.method) {

                case "addConfigs":

                    Map<String, Map<String, Object>> arguments = (Map<String, Map<String, Object>>) methodCall.arguments;

                    for (Map.Entry<String, Map<String, Object>> entry : arguments.entrySet()) {
                        configs.put(PluginType.valueOf(entry.getKey()), new JSONObject(entry.getValue()));
                    }

                    themeExtensionPoint.addConfig(THEME_PLUGIN, configs.get(THEME_PLUGIN));

                    result.success(null);

                    break;

                //-----------------------------------------------------------------------//

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

                    break;

                case "processCustomViewPlugins":
                    System.out.println(">> Processing Custom View Plugins");

                    Map<String, Object> map = customViewExtensionPoint.processPlugins();

                    for(String name : map.keySet()){
                        List<JSONObject> jsonList = (List<JSONObject>) map.get(name);
                        JSONObject json = jsonList.get(0);

                        System.out.println(json);

                        result.success(json.toString());
                    }

                    break;
            }
        });
    }

    private void loadPlugins(List<String> paths, List<String> types, List<String> qualifiedNames, List<String> pluginNames) {

        System.out.println(">> " + paths.size() + " plugins to load");

        for (int i = 0; i < paths.size(); i++) {

            String pluginPath = paths.get(i);
            String qualifiedName = qualifiedNames.get(i);
            String pluginName = pluginNames.get(i);
            String type = types.get(i);

            try {
                File file = new File(pluginPath);

                DexClassLoader loader = new DexClassLoader(file.getPath(), getFilesDir().getPath(), null, this.getClassLoader());
                Class loadedClass = Class.forName(qualifiedName, true, loader);

                switch (PluginType.valueOf(type)) {
                    case THEME_PLUGIN:
                        ((ThemePlugin) loadedClass.newInstance()).plugTo(themeExtensionPoint);
                        break;
                    case CUSTOM_VIEW_PLUGIN:
                        ((CustomViewPlugin) loadedClass.newInstance()).plugTo(customViewExtensionPoint);
                        break;
                }
            } catch (Exception exception) {
                System.out.println("--- Error occurred while trying to load " + type + " : " + pluginName);
                exception.printStackTrace();
                System.out.println("-----------------------------------------------------------");
            }
        }
    }
}
