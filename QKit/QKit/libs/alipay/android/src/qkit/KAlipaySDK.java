package qkit;

import java.lang.String;
import android.util.Log;
import android.annotation.SuppressLint;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
//
import android.view.View;
import qkit.KActivity;
//
import com.alipay.sdk.app.PayTask;

@SuppressLint("HandlerLeak")
public class KAlipaySDK {

        // 商户PID
        public static  String PARTNER = "";
        // 商户收款账号
        public static  String SELLER = "";
        // 商户私钥，pkcs8格式
        public static  String RSA_PRIVATE = "";

        // 回调地址
        public static  String NOTIFY_URL = "";

        private static final int SDK_PAY_FLAG = 1;

        private static final int SDK_CHECK_FLAG = 2;

        private static Handler mHandler = null;

    private static void createHandler(){
        KActivity.s_activity.runOnUiThread(new Runnable()
        {
                public void run()
                {
                        mHandler = new Handler() {
                                public void handleMessage(Message msg) {
                                        switch (msg.what) {
                                        case SDK_PAY_FLAG: {
                                                PayResult payResult = new PayResult((String) msg.obj);
                                                onAlipayResult(payResult.toJsonString());
                                                break;
                                        }
                                        case SDK_CHECK_FLAG: {
                                                //"检查结果为：" + msg.obj

                                                break;
                                        }
                                        default:
                                                break;
                                        }
                                };
                        };
                }

        });
    }


        /**
         * 初始化sdk
         * @param partner
         * @param seller
         * @param privateKey
         */
        public static void initSDK(String partner, String seller, String privateKey, String callbackUrl)
        {
        PARTNER = partner;
                SELLER = seller;
                RSA_PRIVATE = privateKey;
                NOTIFY_URL = callbackUrl;
                if(mHandler == null){
                createHandler();
        }
        }


        /**
         * call alipay sdk pay. 调用SDK支付
         *
         */
    public static void pay(String tradeNo, String title, String description, String price) {

                if (TextUtils.isEmpty(PARTNER) || TextUtils.isEmpty(RSA_PRIVATE) || TextUtils.isEmpty(SELLER)) {
                        Log.e("Alipay:", "PARTNER && RSA_PRIVATE && SELLER cant not empty!");
                        return;
                }

                // 订单
                String orderInfo = getOrderInfo(tradeNo, title, description, price, NOTIFY_URL);

                // 对订单做RSA 签名
                String sign = sign(orderInfo);
                try {
                        // 仅需对sign 做URL编码
                        sign = URLEncoder.encode(sign, "UTF-8");
                } catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                }

                // 完整的符合支付宝参数规范的订单信息
                final String payInfo = orderInfo + "&sign=\"" + sign + "\"&" + getSignType();

                Runnable payRunnable = new Runnable() {

                        @Override
                        public void run() {
                                // 构造PayTask 对象
                                PayTask alipay = new PayTask(KActivity.s_activity);
                                // 调用支付接口，获取支付结果
                                String result = alipay.pay(payInfo);

                                Message msg = new Message();
                                msg.what = SDK_PAY_FLAG;
                                msg.obj = result;
                                mHandler.sendMessage(msg);
                        }
                };

                // 必须异步调用
                Thread payThread = new Thread(payRunnable);
                payThread.start();
        }

        /**
         * check whether the device has authentication alipay account.
         * 查询终端设备是否存在支付宝认证账户
         *
         */
        public static void check(View v) {
                Runnable checkRunnable = new Runnable() {

                        @Override
                        public void run() {
                                // 构造PayTask 对象
                                PayTask payTask = new PayTask(KActivity.s_activity);
                                // 调用查询接口，获取查询结果
                                boolean isExist = payTask.checkAccountIfExist();

                                Message msg = new Message();
                                msg.what = SDK_CHECK_FLAG;
                                msg.obj = isExist;
                                mHandler.sendMessage(msg);
                        }
                };

                Thread checkThread = new Thread(checkRunnable);
                checkThread.start();

        }

        /**
         * get the sdk version. 获取SDK版本号
         *
         */
        public static void getSDKVersion() {
                PayTask payTask = new PayTask(KActivity.s_activity);
                String version = payTask.getVersion();
        }

        /**
         * create the order info. 创建订单信息
         *
         */
        public static String getOrderInfo(String tradeNo, String subject, String body, String price,String callbackUrl) {

                // 签约合作者身份ID
                String orderInfo = "partner=" + "\"" + PARTNER + "\"";

                // 签约卖家支付宝账号
                orderInfo += "&seller_id=" + "\"" + SELLER + "\"";

                // 商户网站唯一订单号
                orderInfo += "&out_trade_no=" + "\"" + tradeNo + "\"";

                // 商品名称
                orderInfo += "&subject=" + "\"" + subject + "\"";

                // 商品详情
                orderInfo += "&body=" + "\"" + body + "\"";

                // 商品金额
                orderInfo += "&total_fee=" + "\"" + price + "\"";

                // 服务器异步通知页面路径
                orderInfo += "&notify_url=" + "\"" + callbackUrl + "\"";

                // 服务接口名称， 固定值
                orderInfo += "&service=\"mobile.securitypay.pay\"";

                // 支付类型， 固定值
                orderInfo += "&payment_type=\"1\"";

                // 参数编码， 固定值
                orderInfo += "&_input_charset=\"utf-8\"";

                // 设置未付款交易的超时时间
                // 默认30分钟，一旦超时，该笔交易就会自动被关闭。
                // 取值范围：1m～15d。
                // m-分钟，h-小时，d-天，1c-当天（无论交易何时创建，都在0点关闭）。
                // 该参数数值不接受小数点，如1.5h，可转换为90m。
                orderInfo += "&it_b_pay=\"30m\"";

                // extern_token为经过快登授权获取到的alipay_open_id,带上此参数用户将使用授权的账户进行支付
                // orderInfo += "&extern_token=" + "\"" + extern_token + "\"";

                // 支付宝处理完请求后，当前页面跳转到商户指定页面的路径，可空
                orderInfo += "&return_url=\"m.alipay.com\"";

                // 调用银行卡支付，需配置此参数，参与签名， 固定值 （需要签约《无线银行卡快捷支付》才能使用）
                // orderInfo += "&paymethod=\"expressGateway\"";

                return orderInfo;
        }


        /**
         * sign the order info. 对订单信息进行签名
         *
         * @param content
         *            待签名订单信息
         */
        public static String sign(String content) {
                return SignUtils.sign(content, RSA_PRIVATE);
        }

        /**
         * get the sign type we use. 获取签名方式
         *
         */
        public static String getSignType() {
                return "sign_type=\"RSA\"";
        }

        public native static void onAlipayResult(String jsonString);
}
