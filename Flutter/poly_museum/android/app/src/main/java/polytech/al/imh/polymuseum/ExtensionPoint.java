package polytech.al.imh.polymuseum;

import org.json.JSONObject;

public abstract class ExtensionPoint {

    public JSONObject getConfigFile(ConfigType configType) {
        return null;
    }

    public enum ConfigType {
        ThemeConfig
    }
}
