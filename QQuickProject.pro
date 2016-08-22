TEMPLATE = app

QT += qml quick positioning multimedia location widgets
QT +=sql

#QT += core-private gui-private qml-private
#QTPLUGIN += qavfcamera qsqlite
QTPLUGIN += qsqlite

SOURCES += main.cpp \
    class/qquickutl.cpp \
    class/httpuploader.cpp \
#    class/qumengqml.cpp \
#    libs/ImagePicker/ImagePicker.cpp
    class/databaseconnect.cpp \
    class/acameracall.cpp \
    class/colormaker.cpp \
    class/callnativecamera.cpp \
    class/callnativecamera_p.cpp \
    class/audio.cpp


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
    class/databaseconnect.h \
    class/acameracall.h \
    class/colormaker.h \
    class/callnativecamera.h \
    class/callnativecamera_p.h \
    class/audio.h

OTHER_FILES += *.qml \
    qml/* \
    qml/api/*   \
    qml/app/*   \
    qml/app/androidSys/*   \
    qml/controls/* \
    qml/js/* \
    qml/toolsbox/* \
    qml/ui/*    \
    qml/ui/animation/*    \
    qml/ui/img/*    \
    qml/ui/components/*    \
    qml/ui/mycase/*    \
    qml/ui/properties/* \
    qml/ui/listview/* \
    qml/ui/qmlcomponents/*  \
    qml/ui/text/*  \
    qml/ui/edit/*  \
    qml/ui/canvas/*  \
    qml/pathviewEx/* \
    qml/ddu/* \

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
    source/music.mp3
    source/videoviewdemo.mp4

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
