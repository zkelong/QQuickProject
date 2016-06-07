#ifndef QUMENGQML_H
#define QUMENGQML_H

#include <QObject>
#include <QQuickItem>

class QUmengQml : public QObject
{
    Q_OBJECT
    Q_ENUMS(_QUMengShare)
public:
     enum _QUMengShare{
            QUMShareToSina = 0, //新浪微博
            QUMShareToTencent, //腾讯微博
            QUMShareToRenren, //人人网
            QUMShareToDouban, //豆瓣
            QUMShareToQzone, //QQ空间
            QUMShareToEmail,//邮箱
            QUMShareToSms, //短信
            QUMShareToWechatSession, //微信好友
            QUMShareToWechatTimeline, //微信朋友圈
            QUMShareToWechatFavorite, //微信收藏
            QUMShareToQQ, //手机QQ
            QUMShareToFacebook, // Facebook
            QUMShareToTwitter, //Twitter
            QUMShareToYXSession, //易信好友
            QUMShareToYXTimeline, //易信朋友圈
            QUMShareToLWSession, //来往好友
            QUMShareToLWTimeline, //来往朋友圈
            QUMShareToInstagram, //分享到Instragram
            QUMShareToWhatsapp, //分享到Whatsapp
            QUMShareToLine, //分享到Line
            QUMShareToTumblr, //分享到Tumblr
            QUMShareToPinterest, //分享到Pinterest
            QUMShareToKakaoTalk, //分享到KakaoTalk
            QUMShareToFlickr, //分享到Flickr
        };

    QUmengQml();
    ~QUmengQml();

    //添加推送别名
    Q_INVOKABLE void addAlias(QString name);

    //移除推送别名
    Q_INVOKABLE void removeAlias(QString name);

    Q_INVOKABLE void presentSnsIconSheetView(QString shareText, QString url, QString shareImage, QList<int> snsNames);

    Q_INVOKABLE void postSNSWithTypes(enum _QUMengShare platformType, QString content, QString url, QString imagePath, QString urlResource);

signals:
    void shareFinished(int errCode, QString errMsg);

public slots:
};

#endif // QUMENGQML_H
