package com.billcoding.flutter_sbox_example;

import android.os.Bundle;
import com.billcoding.flutter_sbox.Sbox;
import io.flutter.embedding.android.FlutterFragmentActivity;

public class MainActivity extends FlutterFragmentActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Sbox.init(Application.application, this, null);
    }
}