#ifndef QQUICKUTL_H
#define QQUICKUTL_H

#include <QObject>
#include <QQuickItem>

class QQuickImage;
class QQuickUtl : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double dpScale READ dpScale)

public:
    explicit QQuickUtl(QObject *parent = 0);
    ~QQuickUtl();

    static QQuickUtl* instance();

    //将指定的像素点转为缩放后的像素点(device point)
    Q_INVOKABLE double dp(double pixel);
    //截屏，返回图片保存地址
    Q_INVOKABLE QString grab();

    //item为QQuickImage对象，此操作将取得其显示的图像保存
    Q_INVOKABLE QString grab(QQuickImage* item);

    Q_INVOKABLE QObject* focusObject();

    double dpScale();

private:
    double dp_scale; //当前设备像素密度和设计像素密度比

signals:

public slots:
};

#endif // QQUICKUTL_H
