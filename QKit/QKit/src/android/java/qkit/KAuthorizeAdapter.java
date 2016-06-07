package qkit;

import cn.sharesdk.framework.authorize.AuthorizeAdapter;

public class KAuthorizeAdapter extends AuthorizeAdapter {

	@Override
	public void onCreate() {		
		super.onCreate();
		hideShareSDKLogo();
	}

}
