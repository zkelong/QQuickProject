#include "kdir.h"
#include <QStandardPaths>
#include <QtDebug>

static KDir* s_dir = nullptr;

KDir::KDir(QObject *parent) : QObject(parent)
{

}

KDir::KDir(const QString & path):m_dir(path)
{

}

KDir::KDir(const QString & path, const QString & nameFilter, SortFlag sort, Filter filters)
    :m_dir(path,nameFilter,(QDir::SortFlags)sort, (QDir::Filters)filters)
{

}

KDir* KDir::instance()
{
    if (!s_dir) {
        s_dir = new KDir();
    }
    return s_dir;
}

void KDir::addResourceSearchPath(const QString &path)
{
    QDir::addResourceSearchPath(path);
}


void KDir::addSearchPath(const QString & prefix, const QString & path)
{
    QDir::addSearchPath(prefix,path);
}

QString KDir::cleanPath(const QString & path)
{
    return QDir::cleanPath(path);
}

KDir* KDir::current()
{
    KDir* d = new KDir();
    d->m_dir = QDir::current();
    return d;
}

QString KDir::currentPath()
{
    return QDir::currentPath();
}

QFileInfoList KDir::drives()
{
    return QDir::drives();
}

QString KDir::fromNativeSeparators(const QString & pathName)
{
    return QDir::fromNativeSeparators(pathName);
}

KDir* KDir::home()
{
    KDir* d = new KDir();
    d->m_dir = QDir::home();
    return d;
}

QString KDir::homePath()
{
    return QDir::homePath();
}

bool KDir::isAbsolutePath(const QString & path)
{
    return QDir::isAbsolutePath(path);
}

bool KDir::isRelativePath(const QString & path)
{
    return QDir::isRelativePath(path);
}

bool KDir::match(const QString & filter, const QString & fileName)
{
    return QDir::match(filter, fileName);
}

bool KDir::match(const QStringList & filters, const QString & fileName)
{
    return QDir::match(filters,fileName);
}

KDir* KDir::root()
{
    KDir* d = new KDir();
    d->m_dir = QDir::root();
    return d;
}

QString KDir::rootPath()
{
    return QDir::rootPath();
}

QStringList KDir::searchPaths(const QString & prefix)
{
    return QDir::searchPaths(prefix);
}

QString KDir::separator()
{
    return QString(QDir::separator());
}

bool KDir::setCurrent(const QString & path)
{
    return QDir::setCurrent(path);
}

void KDir::setSearchPaths(const QString & prefix, const QStringList & searchPaths)
{
    return QDir::setSearchPaths(prefix,searchPaths);
}

KDir* KDir::temp()
{
    KDir* d = new KDir();
    d->m_dir = QDir::temp();
    return d;
}

QString KDir::tempPath()
{
    return QDir::tempPath();
}

QString KDir::toNativeSeparators(const QString & pathName)
{
    return QDir::toNativeSeparators(pathName);
}

QString KDir::absoluteFilePath(const QString & fileName) const
{
    return m_dir.absoluteFilePath(fileName);
}

QString KDir::absolutePath() const
{
    return m_dir.absolutePath();
}

QString KDir::canonicalPath() const
{
    return m_dir.canonicalPath();
}

bool KDir::cd(const QString & dirName)
{
    return m_dir.cd(dirName);
}

bool KDir::cdUp()
{
    return m_dir.cdUp();
}

uint KDir::count() const
{
    return m_dir.count();
}

QString KDir::dirName() const
{
    return m_dir.dirName();
}

/*
QFileInfoList KDir::entryInfoList(const QStringList & nameFilters, Filter filters, SortFlag sort) const
{
    return m_dir.entryInfoList(nameFilters, (QDir::Filters)filters,(QDir::SortFlags)sort);
}

QFileInfoList KDir::entryInfoList(Filter filters , SortFlag sort) const
{
    return m_dir.entryInfoList((QDir::Filters)filters,(QDir::SortFlags)sort);
}
*/

QStringList KDir::entryList(const QStringList & nameFilters, Filter filters, SortFlag sort) const
{
#ifdef Q_OS_IOS
    QString path = m_dir.currentPath();
    if(path.indexOf("assets-library://") == 0){

    }
    return m_dir.entryList(nameFilters, (QDir::Filters)filters,(QDir::SortFlags)sort);
#else
    return QStandardPaths::standardLocations(QStandardPaths::PicturesLocation);
#endif
}

QStringList KDir::entryList(Filter filters, SortFlag sort) const
{
#ifdef Q_OS_IOS
    QString path = m_dir.currentPath();
    if(path.indexOf("assets-library://") == 0){

    }
#else
    return m_dir.entryList((QDir::Filters)filters,(QDir::SortFlags)sort);
#endif
}

bool KDir::exists(const QString & name) const
{
    return m_dir.exists(name);
}

bool KDir::exists() const
{
    return m_dir.exists();
}

QString KDir::filePath(const QString & fileName) const
{
    return m_dir.filePath(fileName);
}

 KDir::Filter KDir::filter() const
{
    return (Filter)(int)m_dir.filter();
}

bool KDir::isAbsolute() const
{
    return m_dir.isAbsolute();
}

bool KDir::isReadable() const
{
    return m_dir.isReadable();
}

bool KDir::isRelative() const
{
    return m_dir.isRelative();
}

bool KDir::isRoot() const
{
    return m_dir.isRoot();
}

bool KDir::makeAbsolute()
{
    return m_dir.makeAbsolute();
}

bool KDir::mkdir(const QString & dirName) const
{
    return m_dir.mkdir(dirName);
}

bool KDir::mkpath(const QString & dirPath) const
{
    return m_dir.mkpath(dirPath);
}

QStringList KDir::nameFilters() const
{
    return m_dir.nameFilters();
}

QString KDir::path() const
{
    return m_dir.path();
}

void KDir::refresh() const
{
    return m_dir.refresh();
}

QString KDir::relativeFilePath(const QString & fileName) const
{
    return m_dir.relativeFilePath(fileName);
}

bool KDir::remove(const QString & fileName)
{
    return m_dir.remove(fileName);
}

bool KDir::removeRecursively()
{
    return m_dir.removeRecursively();
}

bool KDir::rename(const QString & oldName, const QString & newName)
{
    return m_dir.rename(oldName,newName);
}

bool KDir::rmdir(const QString & dirName) const
{
    return m_dir.rmdir(dirName);
}

bool KDir::rmpath(const QString & dirPath) const
{
    return m_dir.rmpath(dirPath);
}

void KDir::setFilter(Filter filters)
{
    return m_dir.setFilter((QDir::Filters) filters);
}

void KDir::setNameFilters(const QStringList & nameFilters)
{
    return m_dir.setNameFilters(nameFilters);
}

void KDir::setPath(const QString & path)
{
    return m_dir.setPath(path);
}

void KDir::setSorting(SortFlag sort)
{
    return m_dir.setSorting( (QDir::SortFlags)sort);
}

KDir::SortFlag KDir::sorting() const
{
    return (SortFlag)(int)m_dir.sorting();
}

void KDir::swap(KDir* other)
{
    m_dir.swap(other->m_dir);
}

QStringList KDir::standardLocations(StandardLocation type)
{
    return QStandardPaths::standardLocations((QStandardPaths::StandardLocation) type);
}

QString KDir::standardPicturesLocation()
{
#ifdef Q_OS_IOS
    return "assets-library://";
#else
    return QStandardPaths::standardLocations(QStandardPaths::PicturesLocation).at(0);
#endif
}

QString KDir::dataLocation()
{
    return QStandardPaths::writableLocation(QStandardPaths::DataLocation);
}

QString KDir::cacheLocation()
{
    return QStandardPaths::writableLocation(QStandardPaths::CacheLocation);
}

KDir* KDir::dir(QString path)
{
    return new KDir(path);
}

QString KDir::dirPath(QString path)
{
    int idx = path.lastIndexOf('/');
    if(idx != -1){
        return path.left(idx);
    }
    return path;
}
