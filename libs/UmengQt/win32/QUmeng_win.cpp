//
//  QUmeng_win.m
//  UmengQt
//
//  Created by fu yuming on 5/21/15.
//  Copyright (c) 2015 fu yuming. All rights reserved.
//

#include "QUmeng_win.h"


QUmeng* QUmeng::instance()
{
    static QUmeng_win s_instance;
    return &s_instance;
}



void QUmeng_win:: startWithAppkey(std::string appKey, RepPolicy reportPolicy, std::string channelId)
{
    m_appkey = appKey;
    UNUSED(reportPolicy);
    UNUSED(channelId);
}

void QUmeng_win:: setLogSendInterval(double second)
{
    UNUSED(second)
}

//======== 推送部分 =========//


void QUmeng_win:: setMessageLogEnabled(bool value)
{
    UNUSED(value)
}

void QUmeng_win:: setBadgeClear(bool value)
{
    UNUSED(value)
}

void QUmeng_win:: clearBadge()
{

}

void QUmeng_win:: setAutoAlert(bool value)
{
    UNUSED(value)
}


void QUmeng_win:: getTags(TagCallback handle)
{
    UNUSED(handle)
}

void QUmeng_win:: addTag(std::string tag,TagCallback handle)
{
    UNUSED(tag)
    UNUSED(handle)
}

void QUmeng_win:: removeTags(std::vector<std::string> &tags ,TagCallback handle)
{
    UNUSED(tags)
    UNUSED(handle)
}


void QUmeng_win:: removeAllTags(TagCallback handle)
{
    UNUSED(handle)
}


void QUmeng_win:: addAlias(std::string name, std::string type, ReqCallback callback)
{
    UNUSED(name);
    UNUSED(type);
    UNUSED(callback);
}

void QUmeng_win:: removeAlias(std::string name, std::string type, ReqCallback handle)
{
    UNUSED(name);
    UNUSED(type);
    UNUSED(handle);
}


//======== 社会化部分 =========//


void QUmeng_win:: setSocialLogEnabled(bool value)
{
    UNUSED(value);
}

void QUmeng_win:: setWXAppId(std::string app_Id ,std::string appSecret , std::string url)
{
    UNUSED(app_Id);
    UNUSED(appSecret);
    UNUSED(url);
}

void QUmeng_win:: openSSOWithRedirectURL(std::string redirectURL)
{
    UNUSED(redirectURL);
}

void QUmeng_win:: setQQWithAppId(std::string appId, std::string appKey, std::string url)
{
    UNUSED(appId);
    UNUSED(appKey);
    UNUSED(url);
}


void QUmeng_win:: setQQSupportWebView(bool supportWebView)
{
    UNUSED(supportWebView);
}


void QUmeng_win:: setFacebookAppID(std::string appID, std::string urlString)
{
    UNUSED(appID);
    UNUSED(urlString);
}


void QUmeng_win:: openTwitter()
{

}

void QUmeng_win:: presentSnsIconSheetView(std::string shareText,std::string url,std::string shareImage, std::list<int>& snsNames, ReqCallback callback)
{
    UNUSED(shareText);
    UNUSED(shareImage);
    UNUSED(snsNames);
    UNUSED(callback);
}

void QUmeng_win:: postSNSWithTypes(QUMengShare platformTypes, std::string content, std::string url,std::string imagePath, std::string urlResource, ReqCallback callback)
{
    UNUSED(platformTypes);
    UNUSED(content);
    UNUSED(imagePath);
    UNUSED(urlResource);
    UNUSED(callback);
}
