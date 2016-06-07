#ifndef QFILETOOLS_H
#define QFILETOOLS_H

#include <QObject>
#include <QDir>

class KDir : public QObject
{
    Q_OBJECT
    Q_ENUMS(StandardLocation)
    Q_ENUMS(Filter)
    Q_ENUMS(SortFlag)
public:
    enum StandardLocation {
        DesktopLocation,
        DocumentsLocation,
        FontsLocation,
        ApplicationsLocation,
        MusicLocation,
        MoviesLocation,
        PicturesLocation,
        TempLocation,
        HomeLocation,
        DataLocation,
        CacheLocation,
        GenericDataLocation,
        RuntimeLocation,
        ConfigLocation,
        DownloadLocation,
        GenericCacheLocation,
        GenericConfigLocation,
        AppDataLocation,
        AppLocalDataLocation = DataLocation
    };

    enum Filter {
      Dirs        = 0x001,
      Files       = 0x002,
      Drives      = 0x004,
      NoSymLinks  = 0x008,
      AllEntries  = Dirs | Files | Drives,
      TypeMask    = 0x00f,

      Readable    = 0x010,
      Writable    = 0x020,
      Executable  = 0x040,
      PermissionMask    = 0x070,

      Modified    = 0x080,
      Hidden      = 0x100,
      System      = 0x200,

      AccessMask  = 0x3F0,

      AllDirs       = 0x400,
      CaseSensitive = 0x800,
      NoDot         = 0x2000,
      NoDotDot      = 0x4000,
      NoDotAndDotDot = NoDot | NoDotDot,

      NoFilter = -1
    };


    enum SortFlag {
        Name        = 0x00,
        Time        = 0x01,
        Size        = 0x02,
        Unsorted    = 0x03,
        SortByMask  = 0x03,

        DirsFirst   = 0x04,
        Reversed    = 0x08,
        IgnoreCase  = 0x10,
        DirsLast    = 0x20,
        LocaleAware = 0x40,
        Type        = 0x80,
        NoSort = -1
    };


public:
    explicit KDir(QObject *parent = 0);
    KDir(const QString & path);
    KDir(const QString & path, const QString & nameFilter, SortFlag sort = SortFlag( Name | IgnoreCase ), Filter filters = AllEntries);

    static KDir *instance();

    //QDir static method
    Q_INVOKABLE void addResourceSearchPath(const QString &path);
    Q_INVOKABLE void addSearchPath(const QString & prefix, const QString & path);
    Q_INVOKABLE QString cleanPath(const QString & path);
    Q_INVOKABLE KDir* current();
    Q_INVOKABLE QString currentPath();
    Q_INVOKABLE QFileInfoList drives();
    Q_INVOKABLE QString fromNativeSeparators(const QString & pathName);
    Q_INVOKABLE KDir* home();
    Q_INVOKABLE QString homePath();
    Q_INVOKABLE bool isAbsolutePath(const QString & path);
    Q_INVOKABLE bool isRelativePath(const QString & path);
    Q_INVOKABLE bool match(const QString & filter, const QString & fileName);
    Q_INVOKABLE bool match(const QStringList & filters, const QString & fileName);
    Q_INVOKABLE KDir* root();
    Q_INVOKABLE QString rootPath();
    Q_INVOKABLE QStringList searchPaths(const QString & prefix);
    Q_INVOKABLE QString separator();
    Q_INVOKABLE bool setCurrent(const QString & path);
    Q_INVOKABLE void setSearchPaths(const QString & prefix, const QStringList & searchPaths);
    Q_INVOKABLE KDir* temp();
    Q_INVOKABLE QString tempPath();
    Q_INVOKABLE QString toNativeSeparators(const QString & pathName);

    //QDir same method
    Q_INVOKABLE QString absoluteFilePath(const QString & fileName) const;
    Q_INVOKABLE QString absolutePath() const;
    Q_INVOKABLE QString canonicalPath() const;
    Q_INVOKABLE bool cd(const QString & dirName);
    Q_INVOKABLE bool cdUp();
    Q_INVOKABLE uint count() const;
    Q_INVOKABLE QString dirName() const;
//    Q_INVOKABLE QFileInfoList entryInfoList(const QStringList & nameFilters, Filter filters = NoFilter, SortFlag sort = NoSort) const;
//    Q_INVOKABLE QFileInfoList entryInfoList(Filter filters = NoFilter, SortFlag sort = NoSort) const;
    Q_INVOKABLE QStringList entryList(const QStringList & nameFilters, Filter filters = NoFilter, SortFlag sort = NoSort) const;
    Q_INVOKABLE QStringList entryList(Filter filters = NoFilter, SortFlag sort = NoSort) const;
    Q_INVOKABLE bool exists(const QString & name) const;
    Q_INVOKABLE bool exists() const;
    Q_INVOKABLE QString filePath(const QString & fileName) const;
    Q_INVOKABLE Filter filter() const;
    Q_INVOKABLE bool isAbsolute() const;
    Q_INVOKABLE bool isReadable() const;
    Q_INVOKABLE bool isRelative() const;
    Q_INVOKABLE bool isRoot() const;
    Q_INVOKABLE bool makeAbsolute();
    Q_INVOKABLE bool mkdir(const QString & dirName) const;
    Q_INVOKABLE bool mkpath(const QString & dirPath) const;
    Q_INVOKABLE QStringList nameFilters() const;
    Q_INVOKABLE QString path() const;
    Q_INVOKABLE void refresh() const;
    Q_INVOKABLE QString relativeFilePath(const QString & fileName) const;
    Q_INVOKABLE bool remove(const QString & fileName);
    Q_INVOKABLE bool removeRecursively();
    Q_INVOKABLE bool rename(const QString & oldName, const QString & newName);
    Q_INVOKABLE bool rmdir(const QString & dirName) const;
    Q_INVOKABLE bool rmpath(const QString & dirPath) const;
    Q_INVOKABLE void setFilter(Filter filters);
    Q_INVOKABLE void setNameFilters(const QStringList & nameFilters);
    Q_INVOKABLE void setPath(const QString & path);
    Q_INVOKABLE void setSorting(SortFlag sort);
    Q_INVOKABLE SortFlag sorting() const;
    Q_INVOKABLE void swap(KDir* other);

    //extensions
    Q_INVOKABLE QStringList standardLocations(StandardLocation type); //将StandardLocation转为实际路径
    Q_INVOKABLE QString standardPicturesLocation(); //取得系统内用户存储图片的标准位置
    Q_INVOKABLE QString dataLocation(); //取得存储应用数据的标准位置
    Q_INVOKABLE QString cacheLocation(); //缓存目录
    Q_INVOKABLE KDir* dir(QString path); //以给定的路径创建一个Dir对象
    Q_INVOKABLE QString dirPath(QString path); //取得所给定路径的上级目录

signals:

public slots:

protected:
    QDir                    m_dir;
};

#endif // QFILETOOLS_H
