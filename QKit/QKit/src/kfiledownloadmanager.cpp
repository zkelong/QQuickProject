#include "kfiledownloadmanager.h"
#include "qkit.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QCryptographicHash>
#include <QFile>
#include <QRegExp>

QString savedName(QUrl url){
    QString su = url.toString();
    QString key = QCryptographicHash::hash(su.toUtf8(),QCryptographicHash::Md5).toHex();
    /*
    QRegExp rx("*\.([a-z0-9A-Z]+)$");
    if(rx.exactMatch(su) && rx.indexIn(su) != -1){
        key += "." + rx.cap(1);
    }
    */
   return key;
}


KFileDownloadManager::KFileDownloadManager(QObject *parent) : QObject(parent)
{
    m_manager = new QNetworkAccessManager();
}

KFileDownloadManager* KFileDownloadManager::instance()
{
    static KFileDownloadManager *s_instance = nullptr;
    if(!s_instance){
        s_instance = new KFileDownloadManager();
    }
    return s_instance;
}

void KFileDownloadManager::addDownloader(KFileDownloader* downloader)
{

    QUrl url(downloader->getUrl());
    QString key = savedName(url);
    QString path = QKit::instance()->runTimeCachePath() + "/" + key;

    if(QFile::exists(path)){
        downloader->_finished(path);
    } else {
        m_lock.lock();
        KFileDownloaderList *list = nullptr;
        auto it = m_map.find(key);
        if(it != m_map.end()){
            list = *it;
        } else {
            list = new KFileDownloaderList();
            QNetworkRequest req;
            req.setUrl(url);
            connect(m_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(replyFinished(QNetworkReply*)));
            m_manager->get(req);
        }
        list->push_back(downloader);
        m_map.insert(key,list);
        m_lock.unlock();
    }
}

void KFileDownloadManager::removeDownloader(KFileDownloader* downloader)
{
    m_lock.lock();
    QUrl url(downloader->getUrl());
    QString key = savedName(url);
    auto it = m_map.find(key);
    if(it != m_map.end()){
        auto list = *it;
        for(auto i = list->begin(); i != list->end(); ++i){
            if(*i == downloader){
                list->erase(i);
                break;
            }
        }
    }
    m_lock.unlock();
}

void KFileDownloadManager::replyFinished(QNetworkReply* reply)
{
    m_lock.lock();
    QString key = savedName(reply->url());
    qDebug() << "***********" << key;
    auto it = m_map.find(key);
    if(it != m_map.end()){
        KFileDownloaderList *list = *it;
        m_map.remove(key);
        m_lock.unlock();

        if(reply->error()){
            QString msg = reply->errorString();
            for(auto i = list->begin(); i != list->end(); ++i){
                emit (*i)->error(msg);
            }
        } else {
            QString path = QKit::instance()->runTimeCachePath() + "/" + key;
            qDebug() << "&&&&&&&&&&&&" << path;
            QFile *file = new QFile(path);
            qint64 len = 0;
            if(file->open(QFile::WriteOnly))
            {
                len = file->write(reply->readAll());
                file->flush();
                file->close();
            }
            delete file;
            if(len == 0){
                handleFinished("", list);
            } else {
                handleFinished(path, list);
            }
        }
        delete list;

    } else {
        m_lock.unlock();
    }
}

void KFileDownloadManager::handleFinished(QString path, KFileDownloaderList *list)
{
    for(auto i = list->begin(); i != list->end(); ++i){
        emit (*i)->_finished(path);
    }
}
