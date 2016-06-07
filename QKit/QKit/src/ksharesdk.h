#ifndef KH
#define KH

#include <QObject>
#include <QMap>
#include <QVariantMap>
#include "ksharesdklistenner.h"

class KShareSDK : public QObject
{
    Q_OBJECT
public:
    explicit KShareSDK(QObject *parent = 0);

    static KShareSDK* instance();

    Q_INVOKABLE void init(QString appName, QString appkey);
    Q_INVOKABLE void setPlatformDevInfo(QString name, QVariantMap info);
    Q_INVOKABLE void showShare(QString title, QString text, QString url, QString imagePath, bool showEdit, KShareSDKListenner* listenner = nullptr);
    Q_INVOKABLE void doShare(QString platform, QString title, QString text, QString url, QString imagePath,KShareSDKListenner* listenner = nullptr);
    Q_INVOKABLE void doLogin(QString platform,KShareSDKListenner* listenner = nullptr);
    
    Q_INVOKABLE void connectSinaWeibo(QString appkey, QString appSecret, QString redirectUri, bool useSSO);
    Q_INVOKABLE void connectTencentWeibo(QString appkey, QString appSecret, QString redirectUri);
    Q_INVOKABLE void connectQZone(QString appkey, QString appSecret,bool useSSO);
    Q_INVOKABLE void connectQQ(QString appkey, QString appSecret);
    Q_INVOKABLE void connectWeChat(QString appkey, QString appSecret);
    Q_INVOKABLE void connectWeChatMoments(QString appkey, QString appSecret);
    Q_INVOKABLE void connectWeChatFavorite(QString appkey, QString appSecret);
    Q_INVOKABLE void connectFacebook(QString appkey, QString appSecret, QString redirectUri);
    Q_INVOKABLE void connectTwitter(QString appkey, QString appSecret, QString redirectUri);
    Q_INVOKABLE void connectRenRen(QString appkey, QString appSecret);
    Q_INVOKABLE void connectRenRen(QString appId, QString appkey, QString appSecret);
    Q_INVOKABLE void connectKaiXin(QString appkey, QString appSecret, QString redirectUri);
    Q_INVOKABLE void connectShortEmail();
    Q_INVOKABLE void connectShortMessage();
    Q_INVOKABLE void connectDouban(QString appkey, QString appSecret, QString redirectUri);
    Q_INVOKABLE void connectYouDaoNote(QString appkey, QString appSecret, QString redirectUri);
    Q_INVOKABLE void connectEvernote(int type, QString appkey, QString appSecret);
    Q_INVOKABLE void connectFourSquare(QString appkey, QString appSecret, QString redirectUri);
    Q_INVOKABLE void connectFlickr(QString appkey, QString appSecret, QString redirectUri);
    Q_INVOKABLE void connectTumblr(QString appkey, QString appSecret, QString redirectUri);
    Q_INVOKABLE void connectDropbox(QString appkey, QString appSecret, QString redirectUri);
    Q_INVOKABLE void connectVKontakte(QString appkey, QString appSecret);
    Q_INVOKABLE void connectInstagram(QString appkey, QString appSecret, QString redirectUri);
    Q_INVOKABLE void connectMingdao(QString appkey, QString appSecret, QString redirectUri);
    Q_INVOKABLE void connectLine();
    Q_INVOKABLE void connectKakaoTalk(QString appkey);
    Q_INVOKABLE void connectKakaoStory(QString appkey);
    Q_INVOKABLE void connectWhatsApp();
    Q_INVOKABLE void connectPocket(QString appkey, QString redirectUri);
    Q_INVOKABLE void connectInstapaper(QString appkey, QString appSecret);
    Q_INVOKABLE void connectAlipay(QString appkey);

signals:

public slots:

private:
    ~KShareSDK(){}
};

#endif // KH
