package qkit;

import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.ActivityManager;
import android.app.ActivityManager.RunningTaskInfo;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import cn.jpush.android.api.JPushInterface;


/**
 * 自定义接收器
 *
 * 如果不定义这个 Receiver，则：
 * 1) 默认用户会打开主界面
 * 2) 接收不到自定义消息
 */
public class PushReceiver extends BroadcastReceiver {
        private static final String TAG = "JPush";

        @SuppressWarnings("deprecation")
        @Override
        public void onReceive(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();
                Log.d(TAG, "[MyReceiver] onReceive - " + intent.getAction() + ", extras: " + printBundle(bundle));

        if (JPushInterface.ACTION_REGISTRATION_ID.equals(intent.getAction())) {
            String regId = bundle.getString(JPushInterface.EXTRA_REGISTRATION_ID);
            Log.d(TAG, "[PushReceiver] 接收Registration Id : " + regId);
            //send the Registration Id to your server...

        } else if (JPushInterface.ACTION_MESSAGE_RECEIVED.equals(intent.getAction())) {
                Log.d(TAG, "[PushReceiver] 接收到推送下来的自定义消息: " + bundle.getString(JPushInterface.EXTRA_MESSAGE));
                //processCustomMessage(context, bundle);

        } else if (JPushInterface.ACTION_NOTIFICATION_RECEIVED.equals(intent.getAction())) {
            Log.d(TAG, "[PushReceiver] 接收到推送下来的通知");
            int notifactionId = bundle.getInt(JPushInterface.EXTRA_NOTIFICATION_ID);
            Log.d(TAG, "[PushReceiver] 接收到推送下来的通知的ID: " + notifactionId);

            String extras = bundle.getString(JPushInterface.EXTRA_EXTRA);
            try {
                if(extras.length() > 0){
                        JSONObject jsonObj = new JSONObject(extras);
                        if(jsonObj.getBoolean("isCall")){
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
                                           processCustomMessage(context, bundle);
                                           KJPush.clearAllNotifications();
                                           return;
                                }
                       }
                       Intent intent2 = context.getPackageManager().getLaunchIntentForPackage(packageName);
                       context.startActivity(intent2);
                       processCustomMessage(context, bundle);
                       KJPush.clearAllNotifications();
                       return;
                        }
                }

                        } catch (JSONException e1) {
                                // TODO Auto-generated catch block
                                e1.printStackTrace();
                        }

            processCustomMessage(context, bundle);

        } else if (JPushInterface.ACTION_NOTIFICATION_OPENED.equals(intent.getAction())) {
            Log.d(TAG, "[PushReceiver] 用户点击打开了通知");
            /*
                //打开自定义的Activity
                Intent i = new Intent(context, TestActivity.class);
                i.putExtras(bundle);
                //i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP );
                context.startActivity(i);
                */

        } else if (JPushInterface.ACTION_RICHPUSH_CALLBACK.equals(intent.getAction())) {
            Log.d(TAG, "[PushReceiver] 用户收到到RICH PUSH CALLBACK: " + bundle.getString(JPushInterface.EXTRA_EXTRA));
            //在这里根据 JPushInterface.EXTRA_EXTRA 的内容处理代码，比如打开新的Activity， 打开一个网页等..

        } else if(JPushInterface.ACTION_CONNECTION_CHANGE.equals(intent.getAction())) {
                boolean connected = intent.getBooleanExtra(JPushInterface.EXTRA_CONNECTION_CHANGE, false);
                Log.w(TAG, "[PushReceiver]" + intent.getAction() +" connected state change to "+connected);
        } else {
                Log.d(TAG, "[PushReceiver] Unhandled intent - " + intent.getAction());
        }
        }

        // 打印所有的 intent extra 数据
        private static String printBundle(Bundle bundle) {
                StringBuilder sb = new StringBuilder();
                for (String key : bundle.keySet()) {
                        if (key.equals(JPushInterface.EXTRA_NOTIFICATION_ID)) {
                                sb.append("\nkey:" + key + ", value:" + bundle.getInt(key));
                        }else if(key.equals(JPushInterface.EXTRA_CONNECTION_CHANGE)){
                                sb.append("\nkey:" + key + ", value:" + bundle.getBoolean(key));
                        }
                        else {
                                sb.append("\nkey:" + key + ", value:" + bundle.getString(key));
                        }
                }
                return sb.toString();
        }


        private void processCustomMessage(Context context, Bundle bundle) {
                String message = bundle.getString(JPushInterface.EXTRA_ALERT);
                String extras = bundle.getString(JPushInterface.EXTRA_EXTRA);
                onReceiveNotification(message, extras);
        }


        public native static void onReceiveNotification(String message, String extras);
}
