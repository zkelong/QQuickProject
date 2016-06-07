#include "ksharesdk.h"
#include "ksharesdk_bridge.h"

KShareSDK::KShareSDK(QObject *parent) : QObject(parent)
{

}

KShareSDK* KShareSDK::instance()
{
    static KShareSDK s_shareSDK;
    return &s_shareSDK;
}

void KShareSDK::init(QString appName, QString appkey)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_init(appName, appkey);
#endif
}

void KShareSDK::setPlatformDevInfo(QString name, QVariantMap info)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    QMap<QString, QString> m;
    for(auto it = info.begin(); it != info.end(); ++it){
        m.insert(it.key(), it.value().toString());
    }
    sharesdk_setPlatformDevInfo(name, m);
#endif
}

void KShareSDK::showShare(QString title, QString text, QString url, QString imagePath, bool showEdit, KShareSDKListenner* listenner)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_showShare(title, text, url, imagePath, showEdit, listenner);
#endif
}

void KShareSDK::doShare(QString platform, QString title, QString text, QString url, QString imagePath,KShareSDKListenner* listenner)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_doShare(platform, title, text, url, imagePath, listenner);
#endif
}

void KShareSDK::doLogin(QString platform,KShareSDKListenner* listenner)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_doLogin(platform, listenner);
#endif
}

void KShareSDK::connectSinaWeibo(QString appkey, QString appSecret, QString redirectUri, bool useSSO)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectSinaWeibo(appkey, appSecret, redirectUri, useSSO);
#endif
}

void KShareSDK::connectTencentWeibo(QString appkey, QString appSecret, QString redirectUri)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectTencentWeibo(appkey, appSecret, redirectUri);
#endif
}
void KShareSDK::connectQZone(QString appkey, QString appSecret,bool useSSO)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectQZone(appkey, appSecret, useSSO);
#endif
}
void KShareSDK::connectQQ(QString appkey, QString appSecret)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectQQ(appkey, appSecret);
#endif
}
void KShareSDK::connectWeChat(QString appkey, QString appSecret)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectWeChat(appkey, appSecret);
#endif
}
void KShareSDK::connectWeChatMoments(QString appkey, QString appSecret)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectWeChatMoments(appkey, appSecret);
#endif
}
void KShareSDK::connectWeChatFavorite(QString appkey, QString appSecret)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectWeChatFavorite(appkey, appSecret);
#endif
}
void KShareSDK::connectFacebook(QString appkey, QString appSecret, QString redirectUri)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectFacebook(appkey, appSecret, redirectUri);
#endif
}
void KShareSDK::connectTwitter(QString appkey, QString appSecret, QString redirectUri)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectTwitter(appkey, appSecret, redirectUri);
#endif
}
void KShareSDK::connectRenRen(QString appkey, QString appSecret)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectRenRen(appkey, appSecret);
#endif
}
void KShareSDK::connectRenRen(QString appId, QString appkey, QString appSecret)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectRenRen(appId, appkey, appSecret);
#endif
}
void KShareSDK::connectKaiXin(QString appkey, QString appSecret, QString redirectUri)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectKaiXin(appkey, appSecret, redirectUri);
#endif
}
void KShareSDK::connectShortEmail()
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectShortEmail();
#endif
}
void KShareSDK::connectShortMessage()
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectShortMessage();
#endif
}
void KShareSDK::connectDouban(QString appkey, QString appSecret, QString redirectUri)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectDouban(appkey, appSecret, redirectUri);
#endif
}
void KShareSDK::connectYouDaoNote(QString appkey, QString appSecret, QString redirectUri)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectYouDaoNote(appkey, appSecret, redirectUri);
#endif
}
void KShareSDK::connectEvernote(int type, QString appkey, QString appSecret)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectEvernote(type, appkey, appSecret);
#endif
}
void KShareSDK::connectFourSquare(QString appkey, QString appSecret, QString redirectUri)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectFourSquare(appkey, appSecret, redirectUri);
#endif
}
void KShareSDK::connectFlickr(QString appkey, QString appSecret, QString redirectUri)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectFlickr(appkey, appSecret, redirectUri);
#endif
}
void KShareSDK::connectTumblr(QString appkey, QString appSecret, QString redirectUri)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectTumblr(appkey, appSecret, redirectUri);
#endif
}
void KShareSDK::connectDropbox(QString appkey, QString appSecret, QString redirectUri)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectDropbox(appkey, appSecret, redirectUri);
#endif
}
void KShareSDK::connectVKontakte(QString appkey, QString appSecret)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectVKontakte(appkey, appSecret);
#endif
}
void KShareSDK::connectInstagram(QString appkey, QString appSecret, QString redirectUri)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectInstagram(appkey, appSecret, redirectUri);
#endif
}
void KShareSDK::connectMingdao(QString appkey, QString appSecret, QString redirectUri)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectMingdao(appkey, appSecret, redirectUri);
#endif
}
void KShareSDK::connectLine()
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectLine();
#endif
}
void KShareSDK::connectKakaoTalk(QString appkey)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectKakaoTalk(appkey);
#endif
}
void KShareSDK::connectKakaoStory(QString appkey)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectKakaoStory(appkey);
#endif
}
void KShareSDK::connectWhatsApp()
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectWhatsApp();
#endif
}
void KShareSDK::connectPocket(QString appkey, QString redirectUri)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectPocket(appkey, redirectUri);
#endif
}
void KShareSDK::connectInstapaper(QString appkey, QString appSecret)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectInstapaper(appkey, appSecret);
#endif
}
void KShareSDK::connectAlipay(QString appkey)
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    sharesdk_connectAlipay(appkey);
#endif
}
