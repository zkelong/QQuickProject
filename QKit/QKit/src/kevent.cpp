#include "kevent.h"

KKeyEvent::KKeyEvent(QObject *parent) : QObject(parent)
{

}

KKeyEvent::KKeyEvent(const QKeyEvent *e) : QObject(0)
{
    event = new QKeyEvent(e->type(), e->key(), e->modifiers(), e->text(), false, e->count());
}

KKeyEvent::~KKeyEvent()
{
    if(event){
        delete event;
    }
}


KMouseEvent::KMouseEvent(QObject *parent) : QObject(parent)
{

}

KMouseEvent::~KMouseEvent()
{
    if(event){
        delete event;
    }
}

KMouseEvent::KMouseEvent(const QMouseEvent *e, bool wasHeld, bool isClick, bool isDoubleClick) : QObject(),
    _wasHeld(wasHeld),
    _isClick(isClick),
    _isDoubleClick(isDoubleClick)
{
    event = new QMouseEvent(e->type(), e->localPos(), e->button(), e->buttons(), e->modifiers());
}
