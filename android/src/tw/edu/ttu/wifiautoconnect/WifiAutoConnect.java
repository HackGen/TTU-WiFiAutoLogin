
package tw.edu.ttu.wifiautoconnect;

import tw.edu.ttu.network.NetworkStatus;
import android.os.Bundle;
import android.text.InputType;
import android.view.View;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Toast;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.SharedPreferences;

public class WifiAutoConnect extends Activity {
    public static final String PREF = "ACCOUNT_PREF";
    public static final String PREF_USERNAME = "USERNAME";
    public static final String PREF_PWD = "PASSWORD";

    private EditText usernameEditText;
    private EditText passwordEditText;
    private CheckBox showPasswordCheckBox;

    private NetworkStatus networkStatus;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wifi_auto_connect);

        usernameEditText = (EditText) findViewById(R.id.et_username);
        passwordEditText = (EditText) findViewById(R.id.et_password);
        showPasswordCheckBox = (CheckBox) findViewById(R.id.cb_showpwd);

        networkStatus = new NetworkStatus(this);

        restorePrefs();

    }

    public void showPasswordCheckBoxOnclick(View view) {
        if (showPasswordCheckBox.isChecked()) {
            passwordEditText.setInputType(InputType.TYPE_CLASS_TEXT
                    | InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
        }
        else {
            passwordEditText.setInputType(InputType.TYPE_CLASS_TEXT
                    | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        }
    }

    public void loginBthOnclick(View view) {
    }

    private void restorePrefs() {
        SharedPreferences setting = getSharedPreferences(PREF, 0);
        String username = setting.getString(PREF_USERNAME, "");
        String password = setting.getString(PREF_PWD, "");

        usernameEditText.setText(username);
        passwordEditText.setText(password);
    }

    private void savePrefs() {
        SharedPreferences setting = getSharedPreferences(PREF, 0);
        setting.edit()
                .putString(PREF_USERNAME, usernameEditText.getText().toString())
                .putString(PREF_PWD, passwordEditText.getText().toString())
                .commit();
    }

    @Override
    protected void onResume() {
        super.onResume();

        if (networkStatus.getSSID().compareTo(getString(R.string.ssid)) != 0) {
            Toast.makeText(this, getString(R.string.err_ssid_msg), Toast.LENGTH_LONG).show();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();

        savePrefs();
    }

}
