
CONFIG += c++11

QT += location multimedia

QML_IMPORT_PATH += $$PWD/res
QML_IMPORT_PATH += $$PWD/res/style

INCLUDEPATH += $$PWD/src
RESOURCES += \
    $$PWD/res/qkit.qrc

HEADERS += \
    $$PWD/src/qkit.h \
    $$PWD/src/kdir.h \
    $$PWD/src/kfiletools.h \
    $$PWD/src/imagepickerprovider.h \
    $$PWD/src/kapplication.h \
    $$PWD/src/file_tools.h \
    $$PWD/src/kphotofecther.h \
    $$PWD/src/kfiledownloadmanager.h \
    $$PWD/src/kfiledownloader.h \
    $$PWD/src/kapplicationlistenner.h \
    $$PWD/src/application_state.h \
    $$PWD/src/bridge.h \
    $$PWD/src/http/khttp.h \
    $$PWD/src/http/khttpfield.h \
    $$PWD/src/http/khttpfieldvalue.h \
    $$PWD/src/http/khttpfieldfile.h \
    $$PWD/src/http/khttpdevice.h \
    $$PWD/src/ksharesdk_bridge.h \
    $$PWD/src/ksharesdk.h \
    $$PWD/src/ksharesdklistenner.h \
    $$PWD/src/kjpush_bridge.h \
    $$PWD/src/kjpush.h \
    $$PWD/src/kjpushlistenner.h \
    $$PWD/src/ios/appdelegate_hook.h \
    $$PWD/src/kalipay.h \
    $$PWD/src/alipay_bridge.h \
    $$PWD/src/kalipaylistenner.h \
    $$PWD/src/kwindow.h \
    $$PWD/src/kwindoweventlistenner.h \
    $$PWD/src/kevent.h \
    $$PWD/src/kweixinpay.h \
    $$PWD/src/kweixinpaylistenner.h \
    $$PWD/src/kappstorelistenner.h \
    $$PWD/src/ios/kAppStore.h \
    $$PWD/src/kphonestatelistener.h

SOURCES += \
    $$PWD/src/qkit.cpp \
    $$PWD/src/kdir.cpp \
    $$PWD/src/kfiletools.cpp \
    $$PWD/src/imagepickerprovider.cpp \
    $$PWD/src/kapplication.cpp \
    $$PWD/src/kphotofecther.cpp \
    $$PWD/src/kfiledownloadmanager.cpp \
    $$PWD/src/kfiledownloader.cpp \
    $$PWD/src/kapplicationlistenner.cpp \
    $$PWD/src/application_state.cpp \
    $$PWD/src/http/khttp.cpp \
    $$PWD/src/http/khttpfield.cpp \
    $$PWD/src/http/khttpfieldvalue.cpp \
    $$PWD/src/http/khttpfieldfile.cpp \
    $$PWD/src/http/khttpdevice.cpp \
    $$PWD/src/ksharesdk.cpp \
    $$PWD/src/ksharesdklistenner.cpp \
    $$PWD/src/kjpush.cpp \
    $$PWD/src/kjpushlistenner.cpp \
    $$PWD/src/kalipay.cpp \
    $$PWD/src/kalipaylistenner.cpp \
    $$PWD/src/kwindow.cpp \
    $$PWD/src/kwindoweventlistenner.cpp \
    $$PWD/src/kevent.cpp \
    $$PWD/src/kweixinpay.cpp \
    $$PWD/src/kweixinpaylistenner.cpp \
    $$PWD/src/kappstorelistenner.cpp \
    $$PWD/src/ios/kAppStore.cpp \
    $$PWD/src/kphonestatelistener.cpp

OBJECTIVE_SOURCES += \
    $$PWD/src/ios/file_tools.mm \
    $$PWD/src/ios/bridge.mm \
    $$PWD/libs/jpush/ios/kjpush_ios.mm \
    $$PWD/src/ios/appdelegate_hook.mm \
    $$PWD/src/ios/ksharesdk_ios.mm \
    $$PWD/src/ios/JSONKit.m \
    $$PWD/src/ios/alipay_bridge.mm \
    $$PWD/libs/alipay/ios/APAuthV2Info.m \
    $$PWD/libs/alipay/ios/Order.m \
    $$PWD/libs/alipay/ios/Util/base64.m \
    $$PWD/libs/alipay/ios/Util/openssl_wrapper.m \
    $$PWD/libs/alipay/ios/Util/DataSigner.mm \
    $$PWD/libs/alipay/ios/Util/DataVerifier.mm \
    $$PWD/libs/alipay/ios/Util/MD5DataSigner.m \
    $$PWD/libs/alipay/ios/Util/NSDataEx.m \
    $$PWD/libs/alipay/ios/Util/RSADataSigner.m \
    $$PWD/libs/alipay/ios/Util/RSADataVerifier.m \
    $$PWD/libs/weixin/ios/WXApiManager.m \
    $$PWD/src/ios/weixin_bridge.mm \
    $$PWD/src/ios/kAppStore_bridge.mm \
    $$PWD/src/ios/HYBPhotoPickerManager.m \
    $$PWD/src/http/khttp_iOS.mm

ios{

    QMAKE_LFLAGS += -ObjC

    OBJECTIVE_HEADERS += \
    $$PWD/libs/alipay/ios/APAuthV2Info.h \
    $$PWD/libs/alipay/ios/Order.h \
    $$PWD/libs/alipay/ios/Util/base64.h \
    $$PWD/libs/alipay/ios/Util/config.h \
    $$PWD/libs/alipay/ios/Util/DataSigner.h \
    $$PWD/libs/alipay/ios/Util/DataVerifier.h \
    $$PWD/libs/alipay/ios/Util/MD5DataSigner.h \
    $$PWD/libs/alipay/ios/Util/NSDataEx.h \
    $$PWD/libs/alipay/ios/Util/openssl_wrapper.h \
    $$PWD/libs/alipay/ios/Util/RSADataSigner.h \
    $$PWD/src/ios/HYBPhotoPickerManager.h \
    $$PWD/libs/alipay/ios/Util/RSADataVerifier.h

    #HEADERS += $$PWD/src/http/khttp_iOS.h
    #SOURCES += $$PWD/src/http/khttp_iOS.mm

    LIBS +=  \
    -framework Accounts \
    -framework Social \
    -framework ImageIO \
    -framework AssetsLibrary \
    -framework MobileCoreServices \
    -framework JavaScriptCore \
    -framework ImageIO \
    -framework StoreKit \
    -framework CoreLocation

   # LIBS += -L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/lib \
    LIBS += -licucore -lz -lstdc++ -lsqlite3

    LIBS += -F/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks \
    -framework AdSupport -framework AssetsLibrary -framework CoreMotion -framework MediaPlayer -framework MessageUI

    LIBS += -F $$PWD/libs/sharesdk/ios/libraries/Framework \
        -framework MOBFoundation \
        -framework ShareSDK \
        -framework ShareSDKConnector \
        -framework ShareSDKExtension \
        -framework ShareSDKInterfaceAdapter \
        -framework ShareSDKUI

    LIBS += -F$$PWD/libs/sharesdk/ios/libraries/Extend/QQSDK -framework TencentOpenAPI
    LIBS += -L$$PWD/libs/sharesdk/ios/libraries/Extend/SinaWeiboSDK -lWeiboSDK
    LIBS += -L$$PWD/libs/sharesdk/ios/libraries/Extend/WeChatSDK -lWeChatSDK

    LIBS += -F$$PWD/libs/alipay/ios/libraries -framework AlipaySDK
    LIBS += -L$$PWD/libs/alipay/ios/libraries -lcrypto
    LIBS += -L$$PWD/libs/alipay/ios/libraries -lssl

    bundle.files = $$files($$PWD/libs/sharesdk/ios/libraries/Bundle/*.bundle)
    bundle.files += $$files($$PWD/libs/sharesdk/ios/libraries/Bundle/*.lproj)
    bundle.files += $$files($$PWD/libs/sharesdk/ios/libraries/Extend/QQSDK/*.bundle)
    bundle.files += $$files($$PWD/libs/sharesdk/ios/libraries/Extend/SinaWeiboSDK/*.bundle)
    bundle.files += $$files($$PWD/libs/alipay/ios/libraries/*.bundle)
    QMAKE_BUNDLE_DATA += bundle

    INCLUDEPATH += $$PWD/libs/jpush/ios \
    $$PWD/libs/sharesdk/ios/libraries/Extend/WeChatSDK \
    $$PWD/libs/sharesdk/ios/libraries/Extend/SinaWeiboSDK \
    $$PWD/libs/alipay/ios \
    $$PWD/libs/alipay/ios/openssl \
    $$PWD/libs/alipay/ios/Util \
    $$PWD/libs/AFNetworking

    LIBS += -L$$PWD/libs/jpush/ios -lJPush-ios-2.1.7

    LIBS += -L$$PWD/libs/IAPHelper/lib -lIAPHelper
    LIBS += -L$$PWD/libs/AFNetworking/lib -lAFNetworking

    HEADERS += $$PWD/src/ios/JSONKit.h \
        $$PWD/src/ios/appdelegate_hook.h \
        $$PWD/libs/weixin/ios/WXApiManager.h \
        $$PWD/src/weixin_bridge.h \
        $$PWD/libs/IAPHelper/IAPHelper/IAPHelper.h \
        $$PWD/libs/IAPHelper/IAPHelper/IAPShare.h \
        $$PWD/libs/IAPHelper/IAPHelper/NSString+Base64.h \
        $$PWD/libs/IAPHelper/IAPHelper/SFHFKeychainUtils.h \
        $$PWD/src/ios/kAppStore_bridge.h \
        $$PWD/src/http/khttp_iOS.h
}

#mac: LIBS += -framework CoreServices

android {
    QT += androidextras

    HEADERS += \
        $$PWD/src/android/qsystemdispatcher.h

    SOURCES += $$PWD/src/android/file_tools.cpp \
        $$PWD/src/android/application_state_android.cpp \
        $$PWD/src/android/bridge.cpp \
        $$PWD/src/android/qsystemdispatcher.cpp \
        $$PWD/src/android/ksharesdk_android.cpp \
        $$PWD/src/android/kjpush_android.cpp \
        $$PWD/src/android/alipay_bridge.cpp \
        $$PWD/src/android/weixin_bridge.cpp

    QA_JAVASRC.path = /src/qkit
    QA_JAVASRC.files += $$files($$PWD/src/android/java/qkit/*)
    INSTALLS += QA_JAVASRC

    lib_LIBS.path = /libs
    lib_LIBS.files += $$files($$PWD/libs/android/libs/*)
    INSTALLS += lib_LIBS

    JPUSH_LIBS.path = /libs
    JPUSH_LIBS.files += $$files($$PWD/libs/jpush/android/libs/*)
    INSTALLS += JPUSH_LIBS

    JPUSH_RES.path = /res
    JPUSH_RES.files += $$files($$PWD/libs/jpush/android/res/*)
    INSTALLS += JPUSH_RES

    SHARESDK.path = /
    SHARESDK.files += $$files($$PWD/libs/sharesdk/android/libs/*)
    INSTALLS += SHARESDK

    ALIPAY.path = /
    ALIPAY.files += $$files($$PWD/libs/alipay/android/*)
    INSTALLS += ALIPAY

    WEIXINPAY.path = /
    WEIXINPAY.files += $$files($$PWD/libs/weixin/android/*)
    INSTALLS += WEIXINPAY
}


DISTFILES += \
    $$PWD/src/android/java/qkit/* \
    $$PWD/src/ios/JSONKit.m \
    $$PWD/libs/alipay/ios/APAuthV2Info.m \
    $$PWD/libs/alipay/ios/Order.m \
    $$PWD/libs/alipay/ios/Util/DataSigner.m \
    $$PWD/libs/alipay/ios/Util/DataVerifier.m \
    $$PWD/libs/alipay/ios/Util/MD5DataSigner.m \
    $$PWD/libs/alipay/ios/Util/NSDataEx.m \
    $$PWD/libs/alipay/ios/Util/RSADataSigner.m \
    $$PWD/libs/alipay/ios/Util/RSADataVerifier.m \
    $$PWD/libs/alipay/android/src/qkit/KAlipaySDK.java
