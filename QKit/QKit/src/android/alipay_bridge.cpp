#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <jni.h>

#include "../alipay_bridge.h"
#include <QJsonDocument>
#include <QVariant>
#include "kalipaylistenner.h"
#include <QDebug>

#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT void JNICALL Java_qkit_KAlipaySDK_onAlipayResult(JNIEnv *env, jclass, jstring jsonString)
{
    const char* str = env->GetStringUTFChars(jsonString,NULL);
    qDebug() << "Java_qkit_KAlipaySDK_onAlipayResult:" << str;
    QJsonDocument job = QJsonDocument::fromJson(str);
    QVariant ret = job.toVariant();
    alipay_emit_pay_result(ret);
}

#ifdef __cplusplus
}
#endif

void alipay_init(QString partner, QString seller, QString privateKey, QString notifyUrl, QString iosAppScheme)
{
    Q_UNUSED(iosAppScheme)
    Q_UNUSED(notifyUrl)
    QAndroidJniObject jPartner = QAndroidJniObject::fromString(partner);
    QAndroidJniObject jSeller = QAndroidJniObject::fromString(seller);
    QAndroidJniObject jPrivateKey = QAndroidJniObject::fromString(privateKey);
    QAndroidJniObject jNotifyUrl = QAndroidJniObject::fromString(notifyUrl);

    QAndroidJniObject::callStaticMethod<void>("qkit/KAlipaySDK",
                                              "initSDK",
                                              "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                                              jPartner.object<jstring>(),
                                              jSeller.object<jstring>(),
                                              jPrivateKey.object<jstring>(),
                                              jNotifyUrl.object<jstring>());
}


void alipay_pay(QString tradeNO, QString productName, QString productDescription, QString amount)
{
    QAndroidJniObject jTradeNO = QAndroidJniObject::fromString(tradeNO);
    QAndroidJniObject jProductName = QAndroidJniObject::fromString(productName);
    QAndroidJniObject jProductDescription = QAndroidJniObject::fromString(productDescription);
    QAndroidJniObject jAmount = QAndroidJniObject::fromString(amount);

    QAndroidJniObject::callStaticMethod<void>("qkit/KAlipaySDK",
                                              "pay",
                                              "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                                              jTradeNO.object<jstring>(),
                                              jProductName.object<jstring>(),
                                              jProductDescription.object<jstring>(),
                                              jAmount.object<jstring>());

//    QAndroidJniObject::callStaticObjectMethod("qkit.KAlipaySDK",
//                                              "test",
//                                              "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;",
//                                              jTradeNO.object<jstring>(),
//                                              jProductName.object<jstring>());

//    QAndroidJniObject::callStaticObjectMethod("qkit.SignUtils",
//                                              "sign",
//                                              "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;",
//                                              jTradeNO.object<jstring>(),
//                                              jProductName.object<jstring>());
}
