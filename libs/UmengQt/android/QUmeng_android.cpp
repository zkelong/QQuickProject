//
//  QUmeng_android.m
//  UmengQt
//
//  Created by fu yuming on 5/21/15.
//  Copyright (c) 2015 fu yuming. All rights reserved.
//

#include "QUmeng_android.h"
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>

jobject makeInteger(int val){
    //return QAndroidJniObject::callStaticMethod<jobject>("java/lang/Integer", "valueOf", jint(val));
    QAndroidJniEnvironment env;
    jclass cls = env->FindClass("java/lang/Integer");
    jmethodID methodId = env->GetMethodID(cls, "<init>", "(I)V");
    jobject obj = env->NewObject(cls, methodId, val);
    return obj;
}

QUmeng* QUmeng::instance()
{
    static QUmeng_android s_instance;
    return &s_instance;
}



void QUmeng_android:: startWithAppkey(std::string appKey, RepPolicy reportPolicy, std::string channelId)
{
    m_appkey = appKey;
    UNUSED(reportPolicy);
    UNUSED(channelId);
}

void QUmeng_android:: setLogSendInterval(double second)
{
    UNUSED(second)
}

//======== 推送部分 =========//


void QUmeng_android:: setMessageLogEnabled(bool value)
{
    UNUSED(value)
}

void QUmeng_android:: setBadgeClear(bool value)
{
    UNUSED(value)
}

void QUmeng_android:: clearBadge()
{

}

void QUmeng_android:: setAutoAlert(bool value)
{
    UNUSED(value)
}


void QUmeng_android:: getTags(TagCallback handle)
{
    UNUSED(handle)
}

void QUmeng_android:: addTag(std::string tag,TagCallback handle)
{
    QAndroidJniObject jTag = QAndroidJniObject::fromString(QString::fromStdString(tag));
    QAndroidJniObject::callStaticMethod<void>(
        "cn/superlink/qt/SLActivity",
        "addPushTag",
        "(Ljava/lang/String;)V",
        jTag.object<jstring>()
   );
    handle(nullptr,0,nullptr);
}

void QUmeng_android:: removeTags(std::vector<std::string> &tags ,TagCallback handle)
{
    QAndroidJniObject jTag = QAndroidJniObject::fromString(QString::fromStdString(tags[0]));
    QAndroidJniObject::callStaticMethod<void>(
        "cn/superlink/qt/SLActivity",
        "delPushTag",
        "(Ljava/lang/String;)V",
        jTag.object<jstring>()
   );
    handle(nullptr,0,nullptr);
}


void QUmeng_android:: removeAllTags(TagCallback handle)
{
    UNUSED(handle)
}


void QUmeng_android:: addAlias(std::string name, std::string type, ReqCallback callback)
{
    QAndroidJniObject jTag = QAndroidJniObject::fromString(QString::fromStdString(name));
    QAndroidJniObject jType = QAndroidJniObject::fromString(QString::fromStdString(type));
    QAndroidJniObject::callStaticMethod<void>(
        "cn/superlink/qt/SLActivity",
        "addPushAlias",
        "(Ljava/lang/String;Ljava/lang/String;)V",
        jTag.object<jstring>(),
        jType.object<jstring>()
   );
    callback(nullptr);
}

void QUmeng_android:: removeAlias(std::string name, std::string type, ReqCallback handle)
{
    QAndroidJniObject jTag = QAndroidJniObject::fromString(QString::fromStdString(name));
    QAndroidJniObject jType = QAndroidJniObject::fromString(QString::fromStdString(type));
    QAndroidJniObject::callStaticMethod<void>(
        "cn/superlink/qt/SLActivity",
        "delPushAlias",
        "(Ljava/lang/String;Ljava/lang/String;)V",
        jTag.object<jstring>(),
        jType.object<jstring>()
   );
    handle(nullptr);
}


//======== 社会化部分 =========//


void QUmeng_android:: setSocialLogEnabled(bool value)
{
    UNUSED(value);
}

void QUmeng_android:: setWXAppId(std::string app_Id ,std::string appSecret , std::string url)
{

    QAndroidJniObject jAppId = QAndroidJniObject::fromString(QString::fromStdString(app_Id));
    QAndroidJniObject jAppSecret = QAndroidJniObject::fromString(QString::fromStdString(appSecret));
    QAndroidJniObject jUrl = QAndroidJniObject::fromString(QString::fromStdString(url));
    QAndroidJniObject::callStaticMethod<void>(
        "cn/superlink/qt/SLActivity",
        "setWXAppId",
        "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
        jAppId.object<jstring>(),
        jAppSecret.object<jstring>(),
        jUrl.object<jstring>()
   );
}

void QUmeng_android:: openSSOWithRedirectURL(std::string redirectURL)
{
    UNUSED(redirectURL);
}

void QUmeng_android:: setQQWithAppId(std::string appId, std::string appKey, std::string url)
{
    QAndroidJniObject jAppId = QAndroidJniObject::fromString(QString::fromStdString(appId));
    QAndroidJniObject jAppSecret = QAndroidJniObject::fromString(QString::fromStdString(appKey));
    QAndroidJniObject jUrl = QAndroidJniObject::fromString(QString::fromStdString(url));
    QAndroidJniObject::callStaticMethod<void>(
        "cn/superlink/qt/SLActivity",
        "setQQWithAppId",
        "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
        jAppId.object<jstring>(),
        jAppSecret.object<jstring>(),
        jUrl.object<jstring>()
   );
}


void QUmeng_android:: setQQSupportWebView(bool supportWebView)
{
    UNUSED(supportWebView);
}


void QUmeng_android:: setFacebookAppID(std::string appID, std::string urlString)
{
    UNUSED(appID);
    UNUSED(urlString);
}


void QUmeng_android:: openTwitter()
{

}

void QUmeng_android:: presentSnsIconSheetView(std::string shareText,std::string url,std::string shareImage, std::list<int>& snsNames, ReqCallback callback)
{   
    QAndroidJniObject jshareText = QAndroidJniObject::fromString(QString::fromStdString(shareText));
    QAndroidJniObject jshareImage = QAndroidJniObject::fromString(QString::fromStdString(shareImage));
    QAndroidJniObject jUrl = QAndroidJniObject::fromString(url.c_str());

    QAndroidJniEnvironment env;
    jclass classArrayList = env->FindClass("java/util/ArrayList");
    jmethodID construct = env->GetMethodID(classArrayList ,"<init>","()V");
    jobject obj_arr = env->NewObject(classArrayList, construct, "");
    jmethodID arr_add = env->GetMethodID(classArrayList, "add", "(Ljava/lang/Object;)Z");

    for(std::list<int>::iterator it = snsNames.begin(); it != snsNames.end(); ++it){
        env->CallObjectMethod(obj_arr, arr_add, makeInteger(*it));
    }

    QAndroidJniObject::callStaticMethod<void>(
        "cn/superlink/qt/SLActivity",
        "presentSnsIconSheetView",
        "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/ArrayList;)V",
        jshareText.object<jstring>(),
        jUrl.object<jstring>(),
        jshareImage.object<jstring>(),
        obj_arr
   );
}


void QUmeng_android:: postSNSWithTypes(QUMengShare platformTypes, std::string content, std::string url,std::string imagePath, std::string urlResource, ReqCallback callback)
{
    jobject platform = makeInteger(platformTypes);
    QAndroidJniObject jshareText = QAndroidJniObject::fromString(QString::fromStdString(content));
    QAndroidJniObject jshareImage = QAndroidJniObject::fromString(QString::fromStdString(imagePath));
    QAndroidJniObject jUrl = QAndroidJniObject::fromString(url.c_str());
    QAndroidJniObject jurlResourcel = QAndroidJniObject::fromString(QString::fromStdString(urlResource));

    QAndroidJniObject::callStaticMethod<void>(
        "cn/superlink/qt/SLActivity",
        "postSNSWithType",
        "(Ljava/lang/Integer;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
        platform,
        jshareText.object<jstring>(),
        jUrl.object<jstring>(),
        jshareImage.object<jstring>(),
        jurlResourcel.object<jstring>()
   );
}
