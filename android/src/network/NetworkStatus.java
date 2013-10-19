
package network;

import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;

public class NetworkStatus {
    private WifiManager wifiManager;
    private WifiInfo wifiInfo;

    public NetworkStatus(Context context) {
        wifiManager = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
    }

    public void update() {
        wifiInfo = wifiManager.getConnectionInfo();
    }

    public String getSSID() {
        update();
        String ssid = wifiInfo.getSSID();

        if (ssid.startsWith("\"") && ssid.endsWith("\"")) {
            ssid = ssid.substring(1, ssid.length() - 1);
        }

        return ssid;
    }

}
