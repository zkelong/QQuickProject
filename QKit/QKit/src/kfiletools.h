#ifndef KFILETOOLS_H
#define KFILETOOLS_H

#include <QObject>
#include <QStringList>
#include <qurl.h>


class KFileTools : public QObject
{
    Q_OBJECT
public:
    explicit KFileTools(QObject *parent = 0);
    static KFileTools* instance();

    // 根据宽高缩放图片
    // @param path 原图路径
    // @param maxWidth 最大宽度, 如果宽高都超过了限制那么会使用超出最大的一边最为最终缩放比例
    // @param maxHeight 最大高度
    QImage scaleImage(QString path, int maxWidth, int maxHeight);

    // 根据宽高的乘积缩放图片
    // @param path 原图路径
    // @param maxArea 最大的宽高乘积
    QImage scaleImage(QString path, int maxArea);

    //将指定的特殊路径(iOS相册)转为可读取的路径
    Q_INVOKABLE QString readablePath(QString path);

    //读取assets目录文件(android),程序目录文件(ios）
    Q_INVOKABLE QString assetsPath(QString srcPath);
    //同上
    Q_INVOKABLE QUrl assetsUrl(QString srcPath);

    //旋转图片
    Q_INVOKABLE QString rotateImage(QString path, qreal angle);

signals:

public slots:
};

#endif // KFILETOOLS_H
