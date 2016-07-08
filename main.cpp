#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QFont>
#include "class/qquickutl.h"
#include "KShareSDK.h"
#include "class/httpuploader.h"
#include <string>
#include "kapplication.h"
#include "qkit.h"
#include "class/acameracall.h"
#include "class/colormaker.h"

int main(int argc, char *argv[])
{
//    QGuiApplication app(argc, argv);

    qmlRegisterUncreatableType<HttpPostField>("HttpUp", 1, 0, "HttpPostField", "Can't touch this");
    qmlRegisterType<HttpPostFieldValue>("HttpUp", 1, 0, "HttpPostFieldValue");
    qmlRegisterType<HttpPostFieldFile>("HttpUp", 1, 0, "HttpPostFieldFile");
    qmlRegisterType<HttpUploader>("HttpUp", 1, 0, "HttpUploader");
    qmlRegisterType<ACameraCall>("ACamera", 1,0, "ACameraCall");
    qmlRegisterType<ColorMaker>("ColorMaker", 1, 0, "ColorMaker");

    KApplication app(argc, argv);
    QFont font;
    font.setFamily("黑体");
    app.setFont(font);
    QQmlApplicationEngine engine;
    QKit::registerTypes(&engine);

    engine.rootContext()->setContextProperty("Utl", QQuickUtl::instance());
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
