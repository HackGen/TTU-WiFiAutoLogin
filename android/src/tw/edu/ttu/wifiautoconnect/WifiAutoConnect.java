
package tw.edu.ttu.wifiautoconnect;

import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;

public class WifiAutoConnect extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wifi_auto_connect);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.wifi_auto_connect, menu);
        return true;
    }

}
