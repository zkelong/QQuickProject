package qkit;

import cn.jpush.android.api.JPushInterface;
import android.media.AudioManager;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.content.Context;
import qkit.KNative;
import android.view.WindowManager;
import android.os.Build;
import android.annotation.TargetApi;
import android.content.pm.PackageManager;
import android.content.pm.PackageInfo;

public class KActivity extends org.qtproject.qt5.android.bindings.QtActivity {

    static {
        KNative.init();
    }

    public static KActivity s_activity;

    private static int currVolume = 0;

    private static boolean translucentStatusBar = false;

    @Override
    public void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);

            if(translucentStatusBar){
                setStatusBarStatus();
            }

            s_activity = this;
            setVolumeControlStream(AudioManager.STREAM_MUSIC);
    }

    @TargetApi(19)
    private void setStatusBarStatus(){
        if (Build.VERSION.SDK_INT >= 19){
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
//            getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
        }
    }


    @Override
    public void onResume() {
            super.onResume();
            KNative.onResume();
            JPushInterface.onResume(this);
    }

    @Override
    public void onPause() {
            super.onPause();
            KNative.onSuspend();
            JPushInterface.onPause(this);
    }

    @Override
    public void onDestroy() {
            super.onDestroy();
            KNative.onDestroy();
    }


    /*
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event)
    {
        if(event.getKeyCode() == KeyEvent.KEYCODE_BACK && event.getAction() == KeyEvent.ACTION_DOWN){
            return true;
        }

        return super.onKeyDown(keyCode,event);
    }
    */

    /*
    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
      if (event.getKeyCode() == KeyEvent.KEYCODE_BACK) {
        if (event.getAction() == KeyEvent.ACTION_DOWN) {
            return true;
        }
      }
      return super.dispatchKeyEvent(event);
    }
    */

    static void enableTranslucentStatusBar()
    {
        if(s_activity != null) {
            s_activity.runOnUiThread(new Runnable()
                {
                        public void run()
                        {
                            s_activity.setStatusBarStatus();
                        }

                });

        } else {
            translucentStatusBar = true;
        }
    }

    static String getUUID()
    {
        final TelephonyManager tm = (TelephonyManager) s_activity.getBaseContext().getSystemService(Context.TELEPHONY_SERVICE);
        final String tmDevice,  androidId;
        tmDevice = "" + tm.getDeviceId();
        androidId = "" + android.provider.Settings.Secure.getString(s_activity.getContentResolver(),android.provider.Settings.Secure.ANDROID_ID);
        String uniqueId = tmDevice  + androidId;
        return uniqueId;
    }

    @SuppressWarnings("deprecation")
    static public void openSpeaker() {
        s_activity.runOnUiThread(new Runnable()
            {
                    public void run()
                    {
                        try{
                            AudioManager audioManager =(AudioManager) s_activity.getSystemService(Context.AUDIO_SERVICE);

                            audioManager.setMode(AudioManager.ROUTE_SPEAKER);

                            currVolume =audioManager.getStreamVolume(AudioManager.STREAM_VOICE_CALL);

                           if(!audioManager.isSpeakerphoneOn()) {
                             audioManager.setSpeakerphoneOn(true);

                              audioManager.setStreamVolume(AudioManager.STREAM_VOICE_CALL,
                                    audioManager.getStreamMaxVolume(AudioManager.STREAM_VOICE_CALL ),
                                    AudioManager.STREAM_VOICE_CALL);
                            }
                       } catch (Exception e) {
                           e.printStackTrace();
                       }
                    }

            });

    }


    static public void closeSpeaker() {
        s_activity.runOnUiThread(new Runnable()
                {
                        public void run()
                        {
                            try {
                                AudioManager audioManager = (AudioManager) s_activity.getSystemService(Context.AUDIO_SERVICE);
                               if(audioManager != null) {
                                   if(audioManager.isSpeakerphoneOn()) {
                                     audioManager.setSpeakerphoneOn(false);
                                     audioManager.setStreamVolume(AudioManager.STREAM_VOICE_CALL,currVolume,
                                                AudioManager.STREAM_VOICE_CALL);
                                   }
                                }
                            } catch (Exception e) {
                               e.printStackTrace();
                            }
                        }

                });

    }

    static public boolean isSpeaker()
    {
        try {
            AudioManager audioManager = (AudioManager) s_activity.getSystemService(Context.AUDIO_SERVICE);
           if(audioManager != null) {
               return audioManager.isSpeakerphoneOn();
            }
        } catch (Exception e) {
           e.printStackTrace();
        }
        return false;
    }


    /**
     * 返回当前程序版本名
     */
    public static String getAppVersionName() {
        String versionName = "";
        int versioncode = 0;
        try {
            // ---get the package info---
            PackageManager pm = s_activity.getPackageManager();
            PackageInfo pi = pm.getPackageInfo(s_activity.getPackageName(), 0);
            versionName = pi.versionName;
            versioncode = pi.versionCode;
            if (versionName == null || versionName.length() <= 0) {
                return "";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return versionName;
    }
}

