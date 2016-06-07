#include "kapplication.h"
#include <QQmlApplicationEngine>
#include <qkit.h>
#include <QDebug>

int main(int argc, char *argv[])
{
    KApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QKit::registerTypes(&engine);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
