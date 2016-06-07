#ifndef KFILEDOWNLOADER_H
#define KFILEDOWNLOADER_H

#include <QObject>

class KFileDownloadManager;

class KFileDownloader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString url READ getUrl WRITE setUrl)
public:
    explicit KFileDownloader(QObject *parent = 0);
    ~KFileDownloader();

    QString getUrl();
    void setUrl(QString url);

    //开始下载
    Q_INVOKABLE void start();
    //停止下载
    Q_INVOKABLE void stop();
    //复制到指定路径(默认下载到临时目录，程序退出时会删除)
    Q_INVOKABLE bool copyToPath(QString file_path);


signals:
    void finished(QString savePath);
    void error(QString errorMsg);

public slots:

protected:
    void _finished(QString savePath);

    QString m_url;
    QString m_path;

    friend class KFileDownloadManager;
};

#endif // KFILEDOWNLOADER_H
