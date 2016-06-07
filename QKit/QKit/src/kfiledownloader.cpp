#include "kfiledownloader.h"
#include "kfiledownloadmanager.h"
#include <QFile>

KFileDownloader::KFileDownloader(QObject *parent) : QObject(parent)
{

}


KFileDownloader::~KFileDownloader()
{
    this->stop();
}


QString KFileDownloader::getUrl()
{
    return m_url;
}

void KFileDownloader::setUrl(QString url)
{
    m_url = url;
}

void KFileDownloader::start()
{
    KFileDownloadManager::instance()->addDownloader(this);
}

void KFileDownloader::stop()
{
    KFileDownloadManager::instance()->removeDownloader(this);
}

bool KFileDownloader::copyToPath(QString file_path)
{
    return QFile::copy(m_path, file_path);
}

void KFileDownloader::_finished(QString savePath)
{
    m_path = savePath;
    emit finished(savePath);
}
