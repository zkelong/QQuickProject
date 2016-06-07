package qkit;

import java.util.HashMap;

import android.util.Log;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.Platform.ShareParams;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.onekeyshare.OnekeyShare;
import qkit.KActivity;

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
                        ShareParams sp = new ShareParams();
                        sp.setTitle(title);
                        sp.setTitleUrl(url);
                        sp.setText(text);
                        sp.setSite(s_appName);
                        sp.setSiteUrl(url);
                        if(imagePath.length() > 0){
                                if(imagePath.indexOf("http") == 0){
                                        sp.setImageUrl(imagePath);
                                } else {
                                        sp.setImageUrl(imagePath);
                                }
                        }
                        Platform pl = ShareSDK.getPlatform(platform);
                        KShareSdk.setHandler(pl);
                        pl.share(sp);

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
                                            KShareSdk.handleAuth(pl);
                                            return;
                                    }
                                    KShareSdk.setHandler(pl);
                                    pl.showUser(null);
                                }

                        });

	}
	
	private static void setHandler(Platform pl)
	{
		pl.setPlatformActionListener(new PlatformActionListener() {
			
			@Override
			public void onError(Platform arg0, int arg1, Throwable arg2) {
				Log.d("KShareSdk", "PlatformAction error");	
				KShareSdk.onPlatformError(arg0.getName());
			}
			
			@Override
			public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
				Log.d("KShareSdk", "PlatformAction complete");	
				KShareSdk.handleAuth(arg0);
			}
			
			@Override
			public void onCancel(Platform arg0, int arg1) {
				Log.d("KShareSdk", "PlatformAction complete");	
				KShareSdk.onPlatformCancel(arg0.getName());
			}
		});
	}
	
	private static void handleAuth(Platform pl)
	{
		String userId = pl.getDb().getUserId();
		String userName = pl.getDb().getUserName();
		String userIcon = pl.getDb().getUserIcon();
		String token = pl.getDb().getToken();
		String tokenSecret = pl.getDb().getTokenSecret();
		long expiresTime = pl.getDb().getExpiresTime();
		KShareSdk.onPlatformComplete(pl.getName(), userId, userName, userIcon, token, tokenSecret, expiresTime);		
	}
	
	//登录或分享失败回调 
	public native static void onPlatformError(String platform);
	//登录或分享成功回调 
	public native static void onPlatformComplete(String platform,String userId, String userName, String userIcon, String token, String tokenSecret, long expiresTime);
	//登录或分享取消回调 
	public native static void onPlatformCancel(String platform);
}
