package polytech.al.imh.polymuseum;

import android.os.Bundle;

import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private static final String PLUGIN_CHANNEL = "channel:alexandre.bolot/plugin";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(this.getFlutterView(), PLUGIN_CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("getMessage")) {
          System.out.println("-- processing plugin call --");

          try {
            File file = new File("../plugins/SimplePlugin.class");

            URLClassLoader child = new URLClassLoader(
                    new URL[]{file.toURI().toURL()},
                    MainActivity.this.getClass().getClassLoader()
            );
            Class classToLoad = Class.forName("plugins.SimplePlugin", true, child);
            Method method = classToLoad.getDeclaredMethod("getMessage");
            Object instance = classToLoad.newInstance();
            String message = (String) method.invoke(instance);

            result.success(message);
          } catch (Exception e) {
            e.printStackTrace();
          }
        }
      }
    });
  }
}
