#ifndef APPLICATION_STATE_H
#define APPLICATION_STATE_H
#include "kapplicationlistenner.h"

void addApplicationListenner(KApplicationListenner* listenner);
void removeApplicationListenner(KApplicationListenner* listenner);

void EmitSuspend();
void EmitResume();
void EmitExit();
void EmitHeartbeat();

#endif // APPLICATION_STATE_H

