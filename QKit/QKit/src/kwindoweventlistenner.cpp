#include "kwindoweventlistenner.h"

extern void addWindowEventListenner(KWindowEventListenner* listenner);
extern void removeWindowEventListenner(KWindowEventListenner* listenner);

KWindowEventListenner::KWindowEventListenner(QObject *parent) : QObject(parent)
{
    addWindowEventListenner(this);
}

KWindowEventListenner::~KWindowEventListenner()
{
    removeWindowEventListenner(this);
}
