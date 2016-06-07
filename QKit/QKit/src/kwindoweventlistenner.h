#ifndef KWINDOWEVENTLISTENNER_H
#define KWINDOWEVENTLISTENNER_H

#include <QObject>
#include <QQuickWindow>
#include <QQuickItem>
#include "kevent.h"

class KWindowEventListenner : public QObject
{
    Q_OBJECT
public:
    explicit KWindowEventListenner(QObject *parent = 0);
    virtual ~KWindowEventListenner();

signals:
    void keyPressEvent(QQuickWindow* window, KKeyEvent *event);
    void keyReleaseEvent(QQuickWindow* window, KKeyEvent *event);
    void mousePressEvent(QQuickWindow* window, KMouseEvent *event);
    void mouseReleaseEvent(QQuickWindow* window, KMouseEvent *event);
    void mouseDoubleClickEvent(QQuickWindow* window, KMouseEvent *event);
    void mouseMoveEvent(QQuickWindow* window, KMouseEvent *event);

    void activeFocusItemChanged(QQuickItem* activeFocusItem);

public slots:
};

#endif // KWINDOWEVENTLISTENNER_H
