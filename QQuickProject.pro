TEMPLATE = app

QT += qml quick positioning multimedia location widgets
#QT += core-private gui-private qml-private
#QTPLUGIN += qavfcamera qsqlite
QTPLUGIN += qsqlite

SOURCES += main.cpp \
    class/qquickutl.cpp \
    class/httpuploader.cpp \
#    class/qumengqml.cpp \
#    libs/ImagePicker/ImagePicker.cpp


RESOURCES += \
    res.qrc \
    qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
#QML_IMPORT_PATH = qml

# Default rules for deployment.
include(deployment.pri)
include(QKit/QKit/qkit.pri)

CONFIG += c++11

HEADERS += \
    class/qquickutl.h \
    class/httpuploader.h \
#    class/qumengqml.h \
#    libs/ImagePicker/ImagePicker.h

OTHER_FILES += *.qml \
    qml/* \
    qml/api/*   \
    qml/app/*   \
    qml/controls/* \
    qml/js/* \
    qml/toolsbox/* \
    qml/ui/*    \
    qml/pathviewEx/* \
    qml/window/* \

win32 {
#    INCLUDEPATH += libs/UmengQt/src
#    SOURCES += libs/UmengQt/win32/QUmeng_win.cpp
#    HEADERS += libs/UmengQt/win32/QUmeng_win.h
}

android {
    QT += androidextras
#    INCLUDEPATH += libs/UmengQt/src
#    SOURCES += libs/UmengQt/android/QUmeng_android.cpp
#    HEADERS += libs/UmengQt/android/QUmeng_android.h
}

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
