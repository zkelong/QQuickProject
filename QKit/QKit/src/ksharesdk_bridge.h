#ifndef KSHARESDK_BRIDGE_H
#define KSHARESDK_BRIDGE_H

#include <QObject>
#include "ksharesdklistenner.h"

/**
 * 初始化,需要最先调用
 * @param appName 应用名称，分享时使用
 * @param appkey sharesdk的appkey
 */
void sharesdk_init(QString appName, QString appkey);


/**
 * 设置平台信息
 * @param name 平台名称
 * @param info 平台信息(appkey等)
 */
void sharesdk_setPlatformDevInfo(QString name, QMap<QString, QString> info);

void sharesdk_connectSinaWeibo(QString appkey, QString appSecret, QString redirectUri, bool useSSO);
void sharesdk_connectTencentWeibo(QString appkey, QString appSecret, QString redirectUri);
void sharesdk_connectQZone(QString appkey, QString appSecret,bool useSSO);
void sharesdk_connectQQ(QString appkey, QString appSecret);
void sharesdk_connectWeChat(QString appkey, QString appSecret);
void sharesdk_connectWeChatMoments(QString appkey, QString appSecret);
void sharesdk_connectWeChatFavorite(QString appkey, QString appSecret);
void sharesdk_connectFacebook(QString appkey, QString appSecret, QString redirectUri);
void sharesdk_connectTwitter(QString appkey, QString appSecret, QString redirectUri);
void sharesdk_connectRenRen(QString appkey, QString appSecret);
void sharesdk_connectRenRen(QString appId, QString appkey, QString appSecret);
void sharesdk_connectKaiXin(QString appkey, QString appSecret, QString redirectUri);
void sharesdk_connectShortEmail();
void sharesdk_connectShortMessage();
void sharesdk_connectDouban(QString appkey, QString appSecret, QString redirectUri);
void sharesdk_connectYouDaoNote(QString appkey, QString appSecret, QString redirectUri);
void sharesdk_connectEvernote(int type, QString appkey, QString appSecret);
void sharesdk_connectFourSquare(QString appkey, QString appSecret, QString redirectUri);
void sharesdk_connectFlickr(QString appkey, QString appSecret, QString redirectUri);
void sharesdk_connectTumblr(QString appkey, QString appSecret, QString redirectUri);
void sharesdk_connectDropbox(QString appkey, QString appSecret, QString redirectUri);
void sharesdk_connectVKontakte(QString appkey, QString appSecret);
void sharesdk_connectInstagram(QString appkey, QString appSecret, QString redirectUri);
void sharesdk_connectMingdao(QString appkey, QString appSecret, QString redirectUri);
void sharesdk_connectLine();
void sharesdk_connectKakaoTalk(QString appkey);
void sharesdk_connectKakaoStory(QString appkey);
void sharesdk_connectWhatsApp();
void sharesdk_connectPocket(QString appkey, QString redirectUri);
void sharesdk_connectInstapaper(QString appkey, QString appSecret);
void sharesdk_connectAlipay(QString appkey);


/**
 * 显示分享视图
 * @param title 分享标题
 * @param text 分享的文本
 * @param url 链接地址
 * @param imagePath 图片地址(可以是本地或网络图片)
 * @param showEdit 是否显示编辑框
 */
void sharesdk_showShare(QString title, QString text, QString url, QString imagePath, bool showEdit, KShareSDKListenner* listenner = nullptr);


/**
 * 直接分享
 * @param title 分享标题
 * @param text 分享的文本
 * @param url 链接地址
 * @param imagePath 图片地址(可以是本地或网络图片)
 */
void sharesdk_doShare(QString platform, QString title, QString text, QString url, QString imagePath,KShareSDKListenner* listenner = nullptr);

/**
 * 执行登录授权操作
 * @param platform 平台名称
 */
void sharesdk_doLogin(QString platform,KShareSDKListenner* listenner = nullptr);


#endif // KSHARESDK_BRIDGE_H

