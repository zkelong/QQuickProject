TEMPLATE = app

QT += qml quick

SOURCES += main.cpp

RESOURCES += qml.qrc

INCLUDEPATH += ../QKit/src
QML_ROOT_PATH = ..
# Additional import path used to resolve QML modules in Qt Creator's code model
#QML_IMPORT_PATH = ../QKit/res

# Default rules for deployment.
include(deployment.pri)
include(../QKit/qkit.pri)
