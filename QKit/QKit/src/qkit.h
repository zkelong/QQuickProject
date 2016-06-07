#ifndef QKIT_H
#define QKIT_H

#include <QObject>
#include <QQuickItem>
#include <QQmlApplicationEngine>

class QKit : public QObject
{
    Q_OBJECT
    Q_ENUMS(StatusBarStye)
public:
    enum StatusBarStye {
        StatusBarStyleDefault = 0,
        StatusBarStyleLightContent = 1,
        StatusBarStyleBlackOpaque = 2
    };
    
    explicit QKit(QObject *parent = 0);
    static QKit* instance();
    static void registerTypes(QQmlEngine *engine);

    //将指定的像素点转为缩放后的像素点(device point)
    Q_INVOKABLE qreal dp(qreal pixel);
    Q_INVOKABLE qreal dpValue();
    Q_INVOKABLE qreal dpiValue();

    Q_INVOKABLE QString systemVersion();

    //截屏，返回图片保存地址
    Q_INVOKABLE QString grab();
    Q_INVOKABLE QString grab(QQuickItem* image);
    Q_INVOKABLE QQuickWindow* mainWindow();

    //取得当前的焦点对象 Qt.inputMethod.hide()
    Q_INVOKABLE QObject* focusObject();
    
    //运行时缓存目录，运行结束后要删除
    Q_INVOKABLE QString runTimeCachePath();
    //清除运行时的临时文件(程序退出时会自动清理,如非必需不应主动调用)
    Q_INVOKABLE void cleanRunTimeCache();
    //生成一个给定长度的随机字符串
    Q_INVOKABLE QString randString(int len);

    //获取设备标识符
    Q_INVOKABLE QString getUUID();

    //设置是否使用扬声器播放
    Q_INVOKABLE void setSpeaker(bool value);

    //是否使用扬声器播放
    Q_INVOKABLE bool isSpeaker();
    
    //ios 设置状态栏样式
    Q_INVOKABLE void iOS_setStatusBarStye(int stye);

    //开启沉浸式状态栏(在engine.load之后调用,ios需要在info.plist中将UIViewControllerBasedStatusBarAppearance设置为NO)
    Q_INVOKABLE void enableTranslucentStatusBar(QQmlApplicationEngine *engine);
    Q_INVOKABLE bool isTranslucentStatusBar();

    //获取版本名
    Q_INVOKABLE QString getAppVersionName();

    //使用外部程序打开url
    Q_INVOKABLE bool openUrl(QString url);

signals:

public slots:

private:
    bool    m_isTranslucentStatusBar;
};

#endif // QKIT_H
