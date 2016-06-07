package qkit;

import java.util.HashSet;
import java.util.Set;

import android.util.Log;
import cn.jpush.android.api.JPushInterface;
import cn.jpush.android.api.TagAliasCallback;
import qkit.KActivity;

public class KJPush {

	public static void init()
	{
		JPushInterface.init(KActivity.s_activity);        
	}
	
	public static void setDebugMode(boolean value)
	{
		JPushInterface.setDebugMode(value);
	}
	
	public static void setAlias(String alias)
	{
		JPushInterface.setAlias(KActivity.s_activity, alias, new TagAliasCallback() {
			
			@Override
			public void gotResult(int arg0, String arg1, Set<String> arg2) {
				Log.d("JPush", "setAlias gotResult " + " status=" + arg0 + " alias=" + arg1 + " tags=" + arg2.toString());				
			}
		});
	}
	
	//多个使用,号做分隔
	public static void setTags(String tags)
	{
		String[] ts = tags.split(",");
		HashSet<String> jts = new HashSet<String>();
		for (String item : ts) {
			jts.add(item);
		}
		JPushInterface.setTags(KActivity.s_activity, jts, new TagAliasCallback() {
			
			@Override
			public void gotResult(int arg0, String arg1, Set<String> arg2) {
				Log.d("JPush", "setTags gotResult " + " status=" + arg0 + " alias=" + arg1 + " tags=" + arg2.toString());					
			}
		});
	}
	
	public static void clearAllNotifications()
	{
		JPushInterface.clearAllNotifications(KActivity.s_activity);
	}
}
