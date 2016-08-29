package qkit;

import java.util.HashMap;
import java.util.Iterator;


import android.util.Log;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.Platform.ShareParams;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.wechat.moments.*;
import cn.sharesdk.wechat.favorite.*;
import cn.sharesdk.wechat.friends.Wechat;
import qkit.KActivity;

import java.util.Map.Entry; 

public class KShareSdk {

	public static String s_appName;
	
	/**
	 * 初始化,需要最先调用
	 * @param appName 应用名称，分享时使用
	 * @param appkey sharesdk的appkey
	 */
	public static void init(String appName, String appkey)
	{
                Log.d("KShareSdk", "appName = " + appName + " appkey =" + appkey);
		s_appName = appName;
		if(KActivity.s_activity == null){
			Log.e("KShareSdk", "Can not init KShareSdk, KActivity.s_activity is null!");
			return;
		}
		ShareSDK.initSDK(KActivity.s_activity, appkey);
	}
	
	/**
	 * 设置平台信息
	 * @param name 平台名称
	 * @param info 平台信息(appkey等)
	 */
	public static void setPlatformDevInfo(String name, HashMap<String, Object> info)
	{
		Log.d("KShareSdk", "setPlatformDevInfo: name =" + name + " info = " + info.toString());
		ShareSDK.setPlatformDevInfo(name, info);
	}

	/**
	 * 显示分享视图
	 * @param title 分享标题
	 * @param text 分享的文本
	 * @param url 链接地址
	 * @param imagePath 图片地址(可以是本地或网络图片)
	 * @param showEdit 是否显示编辑框
	 */
	public static void showShare(final String title, final String text, final String url, final String imagePath, final boolean showEdit)
	{
		KActivity.s_activity.runOnUiThread(new Runnable() {
			
			@Override
			public void run() {
				OnekeyShare oks = new OnekeyShare();
				oks.setTitle(title);
				oks.setTitleUrl(url);
				oks.setText(text);
				oks.setSite(s_appName);
				oks.setSiteUrl(url);
				if(imagePath.length() > 0){
					if(imagePath.indexOf("http") == 0){
						oks.setImageUrl(imagePath);
					} else {
						oks.setImageUrl(imagePath);				
					}
				}
				oks.setSilent(!showEdit);
				oks.show(KActivity.s_activity);
				
			}
			
		});		
		
	}
	
	/**
	 * 直接分享
	 * @param title 分享标题
	 * @param text 分享的文本
	 * @param url 链接地址
	 * @param imagePath 图片地址(可以是本地或网络图片)
	 */
         public static void doShare(final String platform,final String title, final String text, final String url, final String imagePath)
         {
             KActivity.s_activity.runOnUiThread(new Runnable() {

                     @Override
                     public void run() {
                         final ShareParams sp = new ShareParams();
                         sp.setTitle(title);
                         sp.setTitleUrl(url);
                         sp.setText(text);
                         sp.setSite(s_appName);
                         sp.setSiteUrl(url);
                         sp.setUrl(url);
                         Log.d("KShareSdk", "platform=" + platform + " title=" + title + " text=" + text + " url=" + url + " imagePath=" + imagePath);
                         if(platform.equals(Wechat.NAME) || platform.equals(WechatMoments.NAME) || platform.equals(WechatFavorite.NAME)){
                                 if(url.length() > 0){
                                         sp.setShareType(Platform.SHARE_WEBPAGE);
                                 } else if(text.length() == 0 && imagePath.length() > 0){
                                         sp.setShareType(Platform.SHARE_IMAGE);
                                 }else {
                                         sp.setShareType(Platform.SHARE_TEXT);
                                 }
                         } else if(platform.equals(SinaWeibo.NAME) && url.length() > 0){
                                 sp.setText(text + url);
                         }
                         if(imagePath.length() > 0){
                                 if(imagePath.indexOf("http") == 0){
                                         sp.setImageUrl(imagePath);
                                 } else {
                                         sp.setImageUrl(imagePath);
                                 }
                         }
                         final Platform pl = ShareSDK.getPlatform(platform);

                         if(platform.equals(SinaWeibo.NAME) && !pl.isAuthValid()){

                                 pl.setPlatformActionListener(new PlatformActionListener() {

                                         @Override
                                         public void onError(Platform arg0, int arg1, Throwable arg2) {
                                                 Log.d("KShareSdk", "PlatformAction error");
                                                     arg2.printStackTrace();
                                                 KShareSdk.onPlatformError(arg0.getName());
                                         }

                                         @Override
                                         public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
                                                 Log.d("KShareSdk", "PlatformAction auth complete now do share");

                                                 KShareSdk.setHandler(pl);
                                                 pl.share(sp);
                                         }

                                         @Override
                                         public void onCancel(Platform arg0, int arg1) {
                                                 Log.d("KShareSdk", "PlatformAction onCancel");
                                                 KShareSdk.onPlatformCancel(arg0.getName());
                                         }
                                 });

                                 pl.showUser(null);
                         } else {
                                 KShareSdk.setHandler(pl);
                                 pl.share(sp);
                         }


                     }

             });

         }
	
	/**
	 * 执行登录授权操作
	 * @param platform 平台名称
	 */
        public static void doLogin(final String platform)
	{
            KActivity.s_activity.runOnUiThread(new Runnable() {

                                @Override
                                public void run() {

                                    Platform pl = ShareSDK.getPlatform(platform);
                                    if(pl.isAuthValid()){
                                            KShareSdk.handleAuth(pl, "");
                                            return;
                                    }
                                    KShareSdk.setHandler(pl);
                                    pl.showUser(null);
                                }

                        });

	}

        public static void doLoginout(final String platform)
        {
            Platform pl = ShareSDK.getPlatform(platform);
            if(pl.isAuthValid()){
                            pl.removeAccount(true);
                    return;
            }
        }
	
	private static void setHandler(Platform pl)
	{
		pl.setPlatformActionListener(new PlatformActionListener() {
			
			@Override
			public void onError(Platform arg0, int arg1, Throwable arg2) {
				Log.d("KShareSdk", "PlatformAction error");	
                                arg2.printStackTrace();
				KShareSdk.onPlatformError(arg0.getName());
			}
			
			@Override
			public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
				Log.d("KShareSdk", "PlatformAction complete");	
				
				KShareSdk.handleAuth(arg0, hashMapToJson(arg2));
			}
			
			@Override
			public void onCancel(Platform arg0, int arg1) {
                                Log.d("KShareSdk", "PlatformAction onCancel");
				KShareSdk.onPlatformCancel(arg0.getName());
			}
		});
	}
	
	public static String hashMapToJson(HashMap<String, Object> map) {  
        String string = "{";  
        for (Iterator<?> it = map.entrySet().iterator(); it.hasNext();) {  
            Entry<?, ?> e = (Entry<?, ?>) it.next();  
            string += "'" + e.getKey() + "':";  
            string += "'" + e.getValue() + "',";  
        }  
        string = string.substring(0, string.lastIndexOf(","));  
        string += "}";  
        return string;  
    }  
	
	private static void handleAuth(Platform pl, String sourceData)
	{
		String userId = pl.getDb().getUserId();
		String userName = pl.getDb().getUserName();
		String userIcon = pl.getDb().getUserIcon();
		String token = pl.getDb().getToken();
		String tokenSecret = pl.getDb().getTokenSecret();
		long expiresTime = pl.getDb().getExpiresTime();
		
		KShareSdk.onPlatformComplete(pl.getName(), userId, userName, userIcon, token, tokenSecret, expiresTime, sourceData);		
	}
	
	//登录或分享失败回调 
	public native static void onPlatformError(String platform);
	//登录或分享成功回调 
	public native static void onPlatformComplete(String platform,String userId, String userName, String userIcon, String token, String tokenSecret, long expiresTime, String sourceData);
	//登录或分享取消回调 
	public native static void onPlatformCancel(String platform);
}
