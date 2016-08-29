//
//  weixin_bridge.h
//  CallCenter
//
//  Created by Yuming on 5/19/16.
//
//

#ifndef WEIXIN_BRIDGE_H
#define WEIXIN_BRIDGE_H
#include <QObject>

void weixin_init(QString appId, QString partnerId, QString package);
void weixin_pay(QString tradeNO, QString nonceStr, QString timestamp, QString sign);

#endif
