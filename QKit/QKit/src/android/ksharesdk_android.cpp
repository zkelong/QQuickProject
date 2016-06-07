#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <jni.h>
#include <QtDebug>
#include "ksharesdk_bridge.h"
#include "ksharesdklistenner.h"



static KShareSDKListenner* s_sharesdk_listenner = nullptr;
static int s_platform_idx = 0;

#ifdef __cplusplus
extern "C" {
#endif

void _onPlatformError(const char* platform);
void _onPlatformComplete(const char* platform,
                         const char* userId,
                         const char* userName,
                         const char* userIcon,
                         const char* token,
                         const char* tokenSecret,
                         long long expiresTime);
void _onPlatformCancel(const char* platform);

JNIEXPORT void JNICALL Java_qkit_KShareSdk_onPlatformError(JNIEnv *env, jclass, jstring platform)
{
    qDebug() << "********** Java_qkit_KShareSdk_onPlatformError";
    const char* c_platform = env->GetStringUTFChars(platform,NULL);
    _onPlatformError(c_platform);
}

JNIEXPORT void JNICALL Java_qkit_KShareSdk_onPlatformComplete(JNIEnv *env, jclass,
                                                              jstring platform,
                                                              jstring userId,
                                                              jstring userName,
                                                              jstring userIcon,
                                                              jstring token,
                                                              jstring tokenSecret,
                                                              jlong expiresTime)
{
    qDebug() << "********** Java_qkit_KShareSdk_onPlatformComplete";
    const char* c_platform = env->GetStringUTFChars(platform,NULL);
    const char* c_userId = env->GetStringUTFChars(userId, NULL);
    const char* c_userName = env->GetStringUTFChars(userName, NULL);
    const char* c_userIcon = env->GetStringUTFChars(userIcon, NULL);
    const char* c_token = env->GetStringUTFChars(token, NULL);
    const char* c_tokenSecret = env->GetStringUTFChars(tokenSecret, NULL);
    _onPlatformComplete(c_platform, c_userId, c_userName, c_userIcon, c_token, c_tokenSecret, (long long)expiresTime);
}

JNIEXPORT void JNICALL Java_qkit_KShareSdk_onPlatformCancel(JNIEnv *env, jclass, jstring platform)
{
    qDebug() << "********** Java_qkit_KShareSdk_onPlatformCancel";
    const char* c_platform = env->GetStringUTFChars(platform,NULL);
    _onPlatformCancel(c_platform);
}

#ifdef __cplusplus
}
#endif

void _onPlatformError(const char* platform)
{
    if(!s_sharesdk_listenner) return;
    emit s_sharesdk_listenner->platformError(platform);
    s_sharesdk_listenner = nullptr;
}

void _onPlatformComplete(const char* platform,
                         const char* userId,
                         const char* userName,
                         const char* userIcon,
                         const char* token,
                         const char* tokenSecret,
                         long long expiresTime)
{
    if(!s_sharesdk_listenner) return;
    emit s_sharesdk_listenner->platformComplete(platform, userId, userName, userIcon, token, tokenSecret, expiresTime);
    s_sharesdk_listenner = nullptr;
}

void _onPlatformCancel(const char* platform)
{
    if(!s_sharesdk_listenner) return;
    emit s_sharesdk_listenner->platformCancel(platform);
    s_sharesdk_listenner = nullptr;
}

jobject mapToJavaHash(QMap<QString, QString>* qm)
{
    QAndroidJniEnvironment env;
    jclass classHash = env->FindClass("java/util/HashMap");
    jmethodID construct = env->GetMethodID(classHash ,"<init>","()V");
    jobject obj_map = env->NewObject(classHash, construct, "");
    jmethodID map_put = env->GetMethodID(classHash, "put", "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;");
    for(auto it = qm->begin(); it != qm->end(); ++it){
        QAndroidJniObject jK = QAndroidJniObject::fromString(it.key());
        QAndroidJniObject jV = QAndroidJniObject::fromString(it.value());
        env->CallObjectMethod(obj_map, map_put, jK.object<jstring>(), jV.object<jstring>());
    }
    return obj_map;
}



/**
 * 初始化,需要最先调用
 * @param appName 应用名称，分享时使用
 * @param appkey sharesdk的appkey
 */
void sharesdk_init(QString appName, QString appkey)
{
    qDebug() << "********** sharesdk_init" << appName << appkey;
    QAndroidJniObject jAppName = QAndroidJniObject::fromString(appName);
    QAndroidJniObject jAppKey = QAndroidJniObject::fromString(appkey);
    QAndroidJniObject::callStaticMethod<void>("qkit/KShareSdk","init","(Ljava/lang/String;Ljava/lang/String;)V",
                                              jAppName.object<jstring>(), jAppKey.object<jstring>());
}

/**
 * 设置平台信息
 * @param name 平台名称
 * @param info 平台信息(appkey等)
 */
void sharesdk_setPlatformDevInfo(QString name, QMap<QString, QString> info)
{
    QAndroidJniEnvironment env;
    qDebug() << "**************** sharesdk_setPlatformDevInfo " << name << info;
    QAndroidJniObject jName = QAndroidJniObject::fromString(name);
    jobject jInfo = mapToJavaHash(&info);
    QAndroidJniObject::callStaticMethod<void>("qkit/KShareSdk","setPlatformDevInfo","(Ljava/lang/String;Ljava/util/HashMap;)V",
                                              jName.object<jstring>(), jInfo);
    env->DeleteLocalRef(jInfo);
}

void sharesdk_connectSinaWeibo(QString appkey, QString appSecret, QString redirectUri, bool useSSO)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppKey", appkey);
    info.insert("AppSecret", appSecret);
    info.insert("RedirectUrl", redirectUri);
    if(useSSO){
        info.insert("ShareByAppClient","true");
    } else {
        info.insert("ShareByAppClient","false");
    }
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("SinaWeibo", info);
}

void sharesdk_connectTencentWeibo(QString appkey, QString appSecret, QString redirectUri)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppKey", appkey);
    info.insert("AppSecret", appSecret);
    info.insert("RedirectUri", redirectUri);
    info.insert("ShareByAppClient","false");
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("TencentWeibo", info);
}


void sharesdk_connectQZone(QString appkey, QString appSecret,bool useSSO)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppId", appkey);
    info.insert("AppKey", appSecret);
    if(useSSO){
        info.insert("ShareByAppClient","true");
    } else {
        info.insert("ShareByAppClient","false");
    }
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("QZone", info);
}


void sharesdk_connectQQ(QString appkey , QString appSecret)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppId", appkey);
    info.insert("AppKey", appSecret);
    info.insert("ShareByAppClient","true");
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("QQ", info);
}


void sharesdk_connectWeChat(QString appkey, QString appSecret)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppId", appkey);
    info.insert("AppSecret", appSecret);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Wechat", info);
}


void sharesdk_connectWeChatMoments(QString appkey, QString appSecret)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppId", appkey);
    info.insert("AppSecret", appSecret);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("WechatMoments", info);
}


void sharesdk_connectWeChatFavorite(QString appkey, QString appSecret)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppId", appkey);
    info.insert("AppSecret", appSecret);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("WechatFavorite", info);
}


void sharesdk_connectFacebook(QString appkey, QString appSecret, QString redirectUri)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("ConsumerKey", appkey);
    info.insert("ConsumerSecret", appSecret);
    info.insert("RedirectUrl", redirectUri);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Facebook", info);
}


void sharesdk_connectTwitter(QString appkey, QString appSecret, QString redirectUri)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("ConsumerKey", appkey);
    info.insert("ConsumerSecret", appSecret);
    info.insert("CallbackUrl", redirectUri);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Twitter", info);
}


void sharesdk_connectRenRen(QString appkey, QString appSecret)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("ApiKey", appkey);
    info.insert("SecretKey", appSecret);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Renren", info);
}


void sharesdk_connectRenRen(QString appId, QString appkey, QString appSecret)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppId", appId);
    info.insert("ApiKey", appkey);
    info.insert("SecretKey", appSecret);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Renren", info);
}


void sharesdk_connectKaiXin(QString appkey, QString appSecret, QString redirectUri)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppKey", appkey);
    info.insert("AppSecret", appSecret);
    info.insert("RedirectUri", redirectUri);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("KaiXin", info);
}


void sharesdk_connectShortEmail()
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Email", info);
}


void sharesdk_connectShortMessage()
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("ShortMessage", info);
}


void sharesdk_connectDouban(QString appkey, QString appSecret, QString redirectUri)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("ApiKey", appkey);
    info.insert("Secret", appSecret);
    info.insert("RedirectUri", redirectUri);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Douban", info);
}


void sharesdk_connectYouDaoNote(QString appkey, QString appSecret, QString redirectUri)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("HostType", "product");
    info.insert("ConsumerKey", appkey);
    info.insert("ConsumerSecret", appSecret);
    info.insert("RedirectUri", redirectUri);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("YouDao", info);
}


void sharesdk_connectEvernote(int type, QString appkey, QString appSecret)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    if(type == 0){
        info.insert("HostType", "sandbox");
    } else if (type == 1) {
        info.insert("HostType", "china");
    } else {
        info.insert("HostType", "product");
    }
    info.insert("ConsumerKey", appkey);
    info.insert("ConsumerSecret", appSecret);
    info.insert("Enable","true");
    info.insert("ShareByAppClient","true");
    sharesdk_setPlatformDevInfo("Evernote", info);
}


void sharesdk_connectFourSquare(QString appkey, QString appSecret, QString redirectUri)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("ClientID", appkey);
    info.insert("ClientSecret", appSecret);
    info.insert("RedirectUrl", redirectUri);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("FourSquare", info);
}


void sharesdk_connectFlickr(QString appkey, QString appSecret, QString redirectUri)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("ApiKey", appkey);
    info.insert("ApiSecret", appSecret);
    info.insert("RedirectUri", redirectUri);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Flickr", info);
}


void sharesdk_connectTumblr(QString appkey, QString appSecret, QString redirectUri)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("OAuthConsumerKey", appkey);
    info.insert("SecretKey", appSecret);
    info.insert("CallbackUrl", redirectUri);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Tumblr", info);
}


void sharesdk_connectDropbox(QString appkey, QString appSecret, QString redirectUri)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppKey", appkey);
    info.insert("AppSecret", appSecret);
    info.insert("RedirectUri", redirectUri);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Dropbox", info);
}


void sharesdk_connectVKontakte(QString appkey, QString appSecret)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("ApplicationId", appkey);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("VKontakte", info);
}


void sharesdk_connectInstagram(QString appkey, QString appSecret, QString redirectUri)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("ClientId", appkey);
    info.insert("ClientSecret", appSecret);
    info.insert("RedirectUri", redirectUri);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Instagram", info);
}


void sharesdk_connectMingdao(QString appkey, QString appSecret, QString redirectUri)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppKey", appkey);
    info.insert("AppSecret", appSecret);
    info.insert("RedirectUri", redirectUri);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Mingdao", info);
}


void sharesdk_connectLine()
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Line", info);
}


void sharesdk_connectKakaoTalk(QString appkey)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppKey", appkey);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("KakaoTalk", info);
}


void sharesdk_connectKakaoStory(QString appkey)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppKey", appkey);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("KakaoStory", info);
}


void sharesdk_connectWhatsApp()
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("WhatsApp", info);
}


void sharesdk_connectPocket(QString appkey, QString redirectUri)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("ConsumerKey", appkey);
    info.insert("RedirectUri", redirectUri);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Pocket", info);
}


void sharesdk_connectInstapaper(QString appkey, QString appSecret)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("ConsumerKey", appkey);
    info.insert("ConsumerSecret", appSecret);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Instapaper", info);
}


void sharesdk_connectAlipay(QString appkey)
{
    s_platform_idx++;
    QMap<QString, QString> info;
    info.insert("SortId",QString::number(s_platform_idx));
    info.insert("AppId", appkey);
    info.insert("Enable","true");
    sharesdk_setPlatformDevInfo("Alipay", info);
}



/**
 * 显示分享视图
 * @param title 分享标题
 * @param text 分享的文本
 * @param url 链接地址
 * @param imagePath 图片地址(可以是本地或网络图片)
 * @param showEdit 是否显示编辑框
 */
void sharesdk_showShare(QString title, QString text, QString url, QString imagePath, bool showEdit, KShareSDKListenner* listenner)
{
    s_sharesdk_listenner = listenner;
    QAndroidJniObject jTitle = QAndroidJniObject::fromString(title);
    QAndroidJniObject jText = QAndroidJniObject::fromString(text);
    QAndroidJniObject jUrl = QAndroidJniObject::fromString(url);
    QAndroidJniObject jImagePath = QAndroidJniObject::fromString(imagePath);
    jboolean jShowEdit = showEdit;
    QAndroidJniObject::callStaticMethod<void>("qkit/KShareSdk","showShare",
                                              "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V",
                                              jTitle.object<jstring>(),
                                              jText.object<jstring>(),
                                              jUrl.object<jstring>(),
                                              jImagePath.object<jstring>(),
                                              jShowEdit);

}


/**
 * 直接分享
 * @param title 分享标题
 * @param text 分享的文本
 * @param url 链接地址
 * @param imagePath 图片地址(可以是本地或网络图片)
 */
void sharesdk_doShare(QString platform, QString title, QString text, QString url, QString imagePath, KShareSDKListenner* listenner)
{
    s_sharesdk_listenner = listenner;
    QAndroidJniObject jPlatform = QAndroidJniObject::fromString(platform);
    QAndroidJniObject jTitle = QAndroidJniObject::fromString(title);
    QAndroidJniObject jText = QAndroidJniObject::fromString(text);
    QAndroidJniObject jUrl = QAndroidJniObject::fromString(url);
    QAndroidJniObject jImagePath = QAndroidJniObject::fromString(imagePath);
    QAndroidJniObject::callStaticMethod<void>("qkit/KShareSdk","doShare",
                                              "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                                              jPlatform.object<jstring>(),
                                              jTitle.object<jstring>(),
                                              jText.object<jstring>(),
                                              jUrl.object<jstring>(),
                                              jImagePath.object<jstring>());
}

/**
 * 执行登录授权操作
 * @param platform 平台名称
 */
void sharesdk_doLogin(QString platform, KShareSDKListenner* listenner)
{
    s_sharesdk_listenner = listenner;
    QAndroidJniObject jPlatform = QAndroidJniObject::fromString(platform);
    QAndroidJniObject::callStaticMethod<void>("qkit/KShareSdk","doLogin",
                                              "(Ljava/lang/String;)V",
                                              jPlatform.object<jstring>());
}


