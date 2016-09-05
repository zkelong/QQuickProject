package qkit;

import cn.jpush.android.api.JPushInterface;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import qkit.KNative;
import android.view.WindowManager;
import android.os.Build;
import android.annotation.TargetApi;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningTaskInfo;
import android.content.pm.PackageManager;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import android.database.Cursor;
import android.location.LocationManager;
import android.provider.MediaStore;
import android.util.Log;
import me.leolin.shortcutbadger.ShortcutBadger;

public class KActivity extends org.qtproject.qt5.android.bindings.QtActivity {

    static {
        KNative.init();
    }
    
    private static final int NONE = 0;
    private static final int PHOTO_GRAPH = 1;// 拍照
    private static final int PHOTO_ZOOM = 2; // 缩放
    private static final int PHOTO_RESOULT = 3;// 结果
    private static String image_path;
    private static boolean is_headset = false; //是否插入了耳机
    static boolean old_speark_state = false; //插入拔耳机之前的扬声器状态

    public static KActivity s_activity;

    private static int currVolume = 0;

    private static boolean translucentStatusBar = false;
    
    HeadsetPlugReceiver headsetPlugReceiver;

    @Override
    public void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);

            if(translucentStatusBar){
                setStatusBarStatus();
            }

            s_activity = this;
            setVolumeControlStream(AudioManager.STREAM_MUSIC);
            createPhoneListener();
            
            
            this.registerHeadsetPlugReceiver();
            
            new Handler().postDelayed(new Runnable(){    
                public void run() {    
                	old_speark_state = KActivity.isSpeaker();
                    AudioManager localAudioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);  
                    is_headset = localAudioManager.isWiredHeadsetOn();
                    if(is_headset){
                    	KActivity.closeSpeaker();
                    }
                }    
             }, 5000);
    }
    
    private void registerHeadsetPlugReceiver(){  
        headsetPlugReceiver  = new HeadsetPlugReceiver ();  
        IntentFilter  filter = new IntentFilter();  
        filter.addAction("android.intent.action.HEADSET_PLUG");  
        registerReceiver(headsetPlugReceiver, filter);  
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
            this.unregisterReceiver(headsetPlugReceiver);
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
    	if(is_headset){
    		old_speark_state = true;
    		return;
    	}
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
                           old_speark_state = true;
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
                               old_speark_state = false;
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


    @SuppressWarnings("deprecation")
    static public ArrayList<String> getLocalImages()
    {
        String[] items = { MediaStore.Images.Media._ID,
                        MediaStore.Images.Media.DATA };
        Cursor cursor = s_activity.managedQuery(
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI, items, null,
                        null, MediaStore.Images.Media._ID + " desc");
        ArrayList<String> paths = null;

        if (cursor != null && cursor.getCount() > 0) {
            paths = new ArrayList<String>();

            for (cursor.moveToFirst(); !cursor.isAfterLast(); cursor.moveToNext()) {
                //Log.d("************1:", cursor.getString(1));
                paths.add(cursor.getString(1));
            }
        }
        return paths;
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

    /**
     * 返回当前程序版本号
     */
    public static String getAppVersionCode() {
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
        return String.valueOf(versioncode);
    }

    /**
     * 返回指定meta信息
     */
    public static String getMetaDataForKey(String key) {
        String resultData = "";
        try {

            // ---get the package info---
            PackageManager pm = s_activity.getPackageManager();
            ApplicationInfo applicationInfo = pm.getApplicationInfo(s_activity.getPackageName(), PackageManager.GET_META_DATA);
            if (applicationInfo != null) {
                if (applicationInfo.metaData != null) {
                    resultData = applicationInfo.metaData.getString(key);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultData;
    }

    public static void openSettings(final String name){
        s_activity.runOnUiThread(new Runnable()
        {
            public void run()
            {
                Intent intent = new Intent(name);
                s_activity.startActivity(intent);
            }

        });
    }

    public static void setApplicationIconBadgeNumber(int val){
        if(val > 0){
                ShortcutBadger.applyCount(s_activity, val);
        } else {
                ShortcutBadger.removeCount(s_activity);
        }
    }
    
    public static String getUserAgent(){
    	return System.getProperty("http.agent");
    }
    
    public static void takeImage(){
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

        image_path = Environment.getExternalStorageDirectory() + "/" + getRandomString(5) + ".jpg";
        File file = new File(image_path);
        if (file.exists()) {
                file.delete();
        }
        intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(file));
        s_activity.startActivityForResult(intent, PHOTO_GRAPH);
    }
    
    public static String getRandomString(int length) { //length表示生成字符串的长度
        String base = "abcdefghijklmnopqrstuvwxyz0123456789";   
        Random random = new Random();   
        StringBuffer sb = new StringBuffer();   
        for (int i = 0; i < length; i++) {   
            int number = random.nextInt(base.length());   
            sb.append(base.charAt(number));   
        }   
        return sb.toString();   
     }   
    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data){
    	if (resultCode == NONE){
    		onImageTook("");
    		return;
    	}
            
    	
    	// 拍照
        if (requestCode == PHOTO_GRAPH) {            
            onImageTook(image_path);
        }
    }
    
    public native static void onImageTook(String path);
    
    //检查是否开启了gps
    public static boolean gpsIsEnabled() {
    	LocationManager locationManager = (LocationManager) s_activity.getSystemService(Context.LOCATION_SERVICE);  
    	// 通过GPS卫星定位，定位级别可以精确到街（通过24颗卫星定位，在室外和空旷的地方定位准确、速度快）  
    	boolean gps = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);  
    	// 通过WLAN或移动网络(3G/2G)确定的位置（也称作AGPS，辅助GPS定位。主要用于在室内或遮盖物（建筑群或茂密的深林等）密集的地方定位）  
    	boolean network = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);  
		if (gps || network) {  
			return true;  
		}  

		return false;  
    }
    
    /** 
     * 监听电话 
     */  
    public void createPhoneListener() {  
        TelephonyManager telephony = (TelephonyManager)getSystemService(Context.TELEPHONY_SERVICE);  
        telephony.listen(new OnePhoneStateListener(),PhoneStateListener.LISTEN_CALL_STATE);  
    }  
    
    /** 
     * 电话状态监听. 
     */  
    class OnePhoneStateListener extends PhoneStateListener{  
        @Override  
        public void onCallStateChanged(int state, String incomingNumber) {  
            Log.i("PhoneStateListener", "[Listener]电话号码:"+incomingNumber);  
            switch(state){  
            case TelephonyManager.CALL_STATE_RINGING:  
                Log.i("PhoneStateListener", "[Listener]等待接电话:"+incomingNumber);  
                break;  
            case TelephonyManager.CALL_STATE_IDLE:  
                Log.i("PhoneStateListener", "[Listener]电话挂断:"+incomingNumber);  
                break;  
            case TelephonyManager.CALL_STATE_OFFHOOK:  
                Log.i("PhoneStateListener", "[Listener]通话中:"+incomingNumber);  
                break;  
            }  
            onPhoneStateChanged(state);
            super.onCallStateChanged(state, incomingNumber);  
        }  
    }  
    
    public native static void onPhoneStateChanged(int state);
    
    
    //从后台进入前台
    public static void becomeToFront(Context context) {
    	String packageName = context.getPackageName();
        Intent intent1 = context.getPackageManager().getLaunchIntentForPackage(packageName);
        ActivityManager manager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        List<RunningTaskInfo> task_info = manager.getRunningTasks(20);
        String className = "";
        for (int i = 0; i < task_info.size(); i++)
        {
                 if (packageName.equals(task_info.get(i).topActivity.getPackageName()))
                 {
                          className = task_info.get(i).topActivity.getClassName();
                          //这里是指从后台返回到前台  前两个的是关键
                           intent1.setAction(Intent.ACTION_MAIN);
                           intent1.addCategory(Intent.CATEGORY_LAUNCHER);
                           try {
                                   intent1.setComponent(new ComponentName(context, Class.forName(className)));
                           } catch (ClassNotFoundException e) {
                               e.printStackTrace();
                           }//
                           intent1.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
                           context.startActivity(intent1);
                           return;
                }
       }
       Intent intent2 = context.getPackageManager().getLaunchIntentForPackage(packageName);
       context.startActivity(intent2);
    }
    
    //是否插入了耳机
    public static boolean isHeadsetOn()
    {
    	return is_headset;
    }
    
    
    private class HeadsetPlugReceiver extends BroadcastReceiver {  
    	  
        @Override  
        public void onReceive(Context context, Intent intent) {  
            // TODO Auto-generated method stub  
              
                if(intent.hasExtra("state")){  
                    if(intent.getIntExtra("state", 0) == 0 ){//耳机拔出
                    	is_headset = false;
                         if(old_speark_state){
                        	 KActivity.openSpeaker();
                         } 
                    }  
                    else if(intent.getIntExtra("state", 0) == 1){//耳机插入
                    	is_headset = true;
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
                }  
        }  
      
    }

    public static void openUrl(final String url){
        s_activity.runOnUiThread(new Runnable() {

                @Override
                public void run() {
                    Intent intent = new Intent();
                    intent.setAction("android.intent.action.VIEW");
                    Uri content_url = Uri.parse(url);
                    intent.setData(content_url);
                    s_activity.startActivity(intent);
                }
        });
    }
}

