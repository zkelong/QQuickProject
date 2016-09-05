package com.superlink.dada.wxapi;


//import com.superlink.dada.R;
import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelpay.PayReq;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;
import android.widget.Toast;
import qkit.KActivity;

public class WXPayEntryActivity extends Activity implements IWXAPIEventHandler{


    static private IWXAPI api = null;

    static private String s_weixinAppId;
    static private String s_partnerId;
    static private String s_package;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setContentView(R.layout.pay_result);
        if(api == null){
            api = WXAPIFactory.createWXAPI(this, s_weixinAppId);
        }
        api.handleIntent(getIntent(), this);
    }

    static public void initWeixinpay(String appId, String partnerId, String _package) {
        s_weixinAppId = appId;
        s_partnerId = partnerId;
        s_package = _package;

        if(api == null){
            api = WXAPIFactory.createWXAPI(KActivity.s_activity, s_weixinAppId);
            api.registerApp(s_weixinAppId);
        }
        //api = WXAPIFactory.createWXAPI(KActivity.s_activity, s_weixinAppId);
        //api.handleIntent(KActivity.s_activity.getIntent(), this);
    }

    static public void pay(final String prepayid, final String noncestr,final String timeStamp, final String sign){

        KActivity.s_activity.runOnUiThread(new Runnable() {

            @Override
            public void run() {

                if(s_partnerId.length() == 0) {
                    AlertDialog.Builder builder = new AlertDialog.Builder(KActivity.s_activity);
                    builder.setTitle("微信支付");
                    builder.setMessage("请先执行初始化操作再调用支付！");
                    builder.show();
                    return;
                }


                PayReq req = new PayReq();
                req.appId           = s_weixinAppId;
                req.partnerId       = s_partnerId;
                req.prepayId        = prepayid;
                req.nonceStr        = noncestr;
                req.timeStamp       = timeStamp;
                req.packageValue    = s_package;
                req.sign            = sign;
                //req.extData           = "app data"; // optional
                Toast.makeText(KActivity.s_activity, "正常调起支付", Toast.LENGTH_SHORT).show();

                api.sendReq(req);
            }

        });

    }

  @Override
  protected void onNewIntent(Intent intent) {
      super.onNewIntent(intent);
      setIntent(intent);
        api.handleIntent(intent, this);
  }

    @Override
    public void onReq(BaseReq req) {
    }

    @Override
    public void onResp(BaseResp resp) {
        Log.d("WXPayEntry", "onPayFinish, errCode = " + resp.errCode);

        if (resp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX) {
//            AlertDialog.Builder builder = new AlertDialog.Builder(KActivity.s_activity);
//            builder.setTitle("微信支付");
//            builder.setMessage(String.valueOf(resp.errCode));
//            builder.show();
            //TextView tx = (TextView)this.findViewById(R.id.wxResultTipText);
            if(resp.errCode == 0) {
                //tx.setText("支付成功");
            } else {
                //tx.setText("支付失败:" + String.valueOf(resp.errCode));
            }

            onPayResult(resp.errCode);
        }
    }

    public native static void onPayResult(int code);
}
