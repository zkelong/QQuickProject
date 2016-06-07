#include "kapplicationlistenner.h"
#include "application_state.h"

KApplicationListenner::KApplicationListenner(QObject *parent) : QObject(parent)
{
    addApplicationListenner(this);
}

KApplicationListenner::~KApplicationListenner()
{
    removeApplicationListenner(this);
}
