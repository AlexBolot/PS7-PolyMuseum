package polytech.al.imh.polymuseum;

import android.os.Bundle;

import java.io.File;
import java.net.URL;
import java.net.URLClassLoader;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import plugins.IPlugin;

public class MainActivity extends FlutterActivity {

    private static final String PLUGIN_CHANNEL = "channel:polytech.al.imh/plugin";
    private static ThemeExtensionPoint themeExtensionPoint = new ThemeExtensionPoint();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(this.getFlutterView(), PLUGIN_CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if (methodCall.method.equals("loadPlugins")) {

                    if (themeExtensionPoint.registeredPlugins().isEmpty()) {

                        System.out.println("-- Adding plugin to plugins --");

                        try {
                            File file = new File("../plugins/SimplePlugin.class");

                            URLClassLoader child = new URLClassLoader(
                                    new URL[]{file.toURI().toURL()},
                                    MainActivity.this.getClass().getClassLoader()
                            );

                            Class classToLoad = Class.forName("plugins.SimplePlugin", true, child);
                            IPlugin plugin = (IPlugin) classToLoad.newInstance();
                            plugin.init(themeExtensionPoint);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }

                    System.out.println("-- processing plugin call --");
                    System.out.println(themeExtensionPoint.getColor());
                    //result.success(extensionPoint.getMessages());
                }
            }
        });
    }
}
