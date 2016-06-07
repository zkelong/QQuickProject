#ifndef KAPPLICATION_H
#define KAPPLICATION_H

#include <QGuiApplication>

class KApplication : public QGuiApplication
{
    Q_OBJECT
public:
#ifdef Q_QDOC
    KApplication(int &argc, char **argv);
#else
    KApplication(int &argc, char **argv, int = QGuiApplication:: ApplicationFlags);
#endif

    int exec();

};

#endif // KAPPLICATION_H
