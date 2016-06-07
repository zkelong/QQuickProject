#ifndef KFILEDOWNLOADMANAGER_H
#define KFILEDOWNLOADMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QMutex>
#include <QMap>
#include <QList>
#include "kfiledownloader.h"

typedef QList<KFileDownloader*> KFileDownloaderList;
typedef QMap<QString, KFileDownloaderList*> KFileDownloaderMap;

class KFileDownloadManager : public QObject
{
    Q_OBJECT
public:
    explicit KFileDownloadManager(QObject *parent = 0);

    static KFileDownloadManager* instance();

    void addDownloader(KFileDownloader* downloader);
    void removeDownloader(KFileDownloader* downloader);
signals:

public slots:
    void replyFinished(QNetworkReply*);

protected:
    void handleFinished(QString path, KFileDownloaderList *list);

    QNetworkAccessManager  *m_manager;
    KFileDownloaderMap      m_map;
    QMutex                  m_lock;
};

#endif // KFILEDOWNLOADMANAGER_H
