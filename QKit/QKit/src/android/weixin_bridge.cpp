
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <jni.h>
#include <QDebug>

#include "../weixin_bridge.h"
#include "../kweixinpaylistenner.h"


#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT void JNICALL Java_com_superlink_dada_wxapi_WXPayEntryActivity_onPayResult(JNIEnv *env, jclass, jint code)
{
    qDebug() << "WXPayEntryActivity_onPayResult:" << code;

    weixinpay_emit_pay_result(code);
}

#ifdef __cplusplus
}
#endif


void weixin_init(QString appId, QString partnerId, QString package)
{
    QAndroidJniObject jappId = QAndroidJniObject::fromString(appId);
    QAndroidJniObject jpartnerId = QAndroidJniObject::fromString(partnerId);
    QAndroidJniObject jpackage = QAndroidJniObject::fromString(package);

    QAndroidJniObject::callStaticMethod<void>("com/superlink/dada/wxapi/WXPayEntryActivity",
                                              "initWeixinpay",
                                              "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                                              jappId.object<jstring>(),
                                              jpartnerId.object<jstring>(),
                                              jpackage.object<jstring>());
}

void weixin_pay(QString tradeNO, QString nonceStr,QString timestamp, QString sign)
{
    QAndroidJniObject jtradeNO = QAndroidJniObject::fromString(tradeNO);
    QAndroidJniObject jnonceStr = QAndroidJniObject::fromString(nonceStr);
    QAndroidJniObject jtimestamp = QAndroidJniObject::fromString(timestamp);
    QAndroidJniObject jsign = QAndroidJniObject::fromString(sign);

    QAndroidJniObject::callStaticMethod<void>("com/superlink/dada/wxapi/WXPayEntryActivity",
                                              "pay",
                                              "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                                              jtradeNO.object<jstring>(),
                                              jnonceStr.object<jstring>(),
                                              jtimestamp.object<jstring>(),
                                              jsign.object<jstring>());
}
