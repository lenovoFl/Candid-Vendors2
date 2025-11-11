package com.seller01.candid

import io.flutter.embedding.android.FlutterFragmentActivity
//import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.FirebaseApp
import android.os.Bundle
import android.util.Log

//import com.google.firebase.appcheck.playintegrity.PlayIntegrityAppCheckProviderFactory

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.e("MainActivity", "onCreate")
        FirebaseApp.initializeApp(/*context=*/ this)
//        FirebaseAppCheck.getInstance().installAppCheckProviderFactory(
//            PlayIntegrityAppCheckProviderFactory.getInstance()
//        )
    }
}
