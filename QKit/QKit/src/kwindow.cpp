#include "kwindow.h"
#include <QDebug>
#include <QCloseEvent>
#include <QMutex>
#include "kwindoweventlistenner.h"


static QList<KWindowEventListenner*> s_window_listenners;
static QMutex       s_window_lock;


KWindow::KWindow(QWindow *parent) : QQuickWindow(parent),m_mousePressed(false)
{
    QObject:: connect( this, &QQuickWindow::activeFocusItemChanged, this, &KWindow::p_activeFocusItemChanged );
    QObject:: connect( this, &QQuickWindow::afterSynchronizing, this, &KWindow::afterSynchronizing );
    QObject:: connect( this, &QQuickWindow::afterAnimating, this, &KWindow::afterAnimating );
    QObject:: connect( this, &QQuickWindow::sceneGraphAboutToStop, this, &KWindow::sceneGraphAboutToStop );
}

void KWindow::p_activeFocusItemChanged()
{
    emit this->activeFocusItemChanged(this->activeFocusItem());
}

void KWindow::keyPressEvent(QKeyEvent *e)
{
    QQuickWindow::keyPressEvent(e);

    s_window_lock.lock();
    KKeyEvent me(e);
    for(auto it = s_window_listenners.begin(); it != s_window_listenners.end(); ++it){
        emit (*it)->keyPressEvent(this, &me);
    }
    s_window_lock.unlock();
}

void KWindow::keyReleaseEvent(QKeyEvent *e)
{
    QQuickWindow::keyReleaseEvent(e);

    s_window_lock.lock();
    KKeyEvent me(e);
    for(auto it = s_window_listenners.begin(); it != s_window_listenners.end(); ++it){
        emit (*it)->keyReleaseEvent(this, &me);
    }
    s_window_lock.unlock();
}


bool KWindow::event(QEvent *event)
{
    bool ret = QQuickWindow::event(event);

    QMouseEvent *e = nullptr;
    QEvent::Type type = event->type();

    //================== press begin ===========//
    if(type == QEvent::Type::MouseButtonPress){
        e = dynamic_cast<QMouseEvent*>(event);
    }else if(type == QEvent::Type::TouchBegin){
        QTouchEvent*te = dynamic_cast<QTouchEvent*>(event);

        QTouchEvent::TouchPoint tpos = te->touchPoints().at(0);
        QPointF pos = tpos.pos();
        e = new QMouseEvent(QEvent::Type::MouseButtonPress, pos, Qt::MouseButton::LeftButton, Qt::MouseButton::LeftButton, Qt::KeyboardModifier::NoModifier);
    }

    if(e){
//        qDebug() << "************* mousePressEvent";
        m_mousePressed = true;
        s_window_lock.lock();
        KMouseEvent me(e, m_mousePressed, false, false);
        for(auto it = s_window_listenners.begin(); it != s_window_listenners.end(); ++it){
            emit (*it)->mousePressEvent(this, &me);
        }
        s_window_lock.unlock();
        return ret;
    }
    //================== press end ===========//


    //================== move begin ===========//
    if(type == QEvent::Type::MouseMove){
        e = dynamic_cast<QMouseEvent*>(event);
    }else if(type == QEvent::Type::TouchUpdate){
        QTouchEvent*te = dynamic_cast<QTouchEvent*>(event);

        QTouchEvent::TouchPoint tpos = te->touchPoints().at(0);
        QPointF pos = tpos.pos();
        e = new QMouseEvent(QEvent::Type::MouseMove, pos, Qt::MouseButton::LeftButton, Qt::MouseButton::LeftButton, Qt::KeyboardModifier::NoModifier);
    }

    if(e){
//        qDebug() << "************* mouseMoveEvent";
        s_window_lock.lock();
        KMouseEvent me(e, m_mousePressed, false, false);
        for(auto it = s_window_listenners.begin(); it != s_window_listenners.end(); ++it){
            emit (*it)->mouseMoveEvent(this, &me);
        }
        s_window_lock.unlock();
        goto END;
    }
    //================== move end ===========//


    //================== release begin ===========//
    if(type == QEvent::Type::MouseButtonRelease){
        e = dynamic_cast<QMouseEvent*>(event);
    }else if(type == QEvent::Type::TouchEnd || type == QEvent::Type::TouchCancel){
        QTouchEvent*te = dynamic_cast<QTouchEvent*>(event);

        QTouchEvent::TouchPoint tpos = te->touchPoints().at(0);
        QPointF pos = tpos.pos();
        e = new QMouseEvent(QEvent::Type::MouseButtonRelease, pos, Qt::MouseButton::LeftButton, Qt::MouseButton::LeftButton, Qt::KeyboardModifier::NoModifier);
    }

    if(e){
//        qDebug() << "************* mouseReleaseEvent";
        m_mousePressed = false;
        s_window_lock.lock();
        KMouseEvent me(e, m_mousePressed, true, false);
        for(auto it = s_window_listenners.begin(); it != s_window_listenners.end(); ++it){
            emit (*it)->mouseReleaseEvent(this, &me);
        }
        s_window_lock.unlock();

    }
    //================== release end ===========//

END:
    if(type == QEvent::Type::TouchEnd || type == QEvent::Type::TouchCancel || QEvent::Type::TouchUpdate || type == QEvent::Type::TouchBegin){
        delete e;
    }

    return ret;
}


void addWindowEventListenner(KWindowEventListenner* listenner)
{
    s_window_lock.lock();
    s_window_listenners.append(listenner);
    s_window_lock.unlock();
}

void removeWindowEventListenner(KWindowEventListenner* listenner)
{
    s_window_lock.lock();
    for(auto it = s_window_listenners.begin(); it != s_window_listenners.end(); ++it){
        if(*it == listenner){
            s_window_listenners.erase(it);
            break;
        }
    }
    s_window_lock.unlock();
}
