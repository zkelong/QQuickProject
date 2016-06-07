#ifndef KEVENT_H
#define KEVENT_H

#include <QObject>
#include <QtGui/qevent.h>

class KKeyEvent : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int key READ key)
    Q_PROPERTY(QString text READ text)
    Q_PROPERTY(int modifiers READ modifiers)
    Q_PROPERTY(bool isAutoRepeat READ isAutoRepeat)
    Q_PROPERTY(int count READ count)
    Q_PROPERTY(quint32 nativeScanCode READ nativeScanCode)
    Q_PROPERTY(bool accepted READ isAccepted WRITE setAccepted)
public:
    explicit KKeyEvent(QObject *parent = 0);
    KKeyEvent(const QKeyEvent *e);
    ~KKeyEvent();

    int key() const { return event->key(); }
    QString text() const { return event->text(); }
    int modifiers() const { return event->modifiers(); }
    bool isAutoRepeat() const { return event->isAutoRepeat(); }
    int count() const { return event->count(); }
    quint32 nativeScanCode() const { return event->nativeScanCode(); }

    bool isAccepted() { return event->isAccepted(); }
    void setAccepted(bool accepted) { event->setAccepted(accepted); }

    Q_INVOKABLE bool matches(QKeySequence::StandardKey key) const { return event->matches(key); }

signals:

public slots:

protected:
    QKeyEvent*      event;
};

class KMouseEvent : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal x READ x)
    Q_PROPERTY(qreal y READ y)
    Q_PROPERTY(int button READ button)
    Q_PROPERTY(int buttons READ buttons)
    Q_PROPERTY(int modifiers READ modifiers)
    Q_PROPERTY(bool wasHeld READ wasHeld)
    Q_PROPERTY(bool isClick READ isClick)
    Q_PROPERTY(bool isDoubleClick READ isDoubleClick)
public:
    explicit KMouseEvent(QObject *parent = 0);
    KMouseEvent(const QMouseEvent *e, bool wasHeld, bool isClick, bool _isDoubleClick);
    ~KMouseEvent();

    qreal x() const { return event->x(); }
    qreal y() const { return event->y(); }
    int button() const { return event->button(); }
    int buttons() const { return event->buttons(); }
    int modifiers() const { return event->modifiers(); }
    bool wasHeld() const { return _wasHeld; }
    bool isClick() const { return _isClick; }
    bool isDoubleClick() const { return _isDoubleClick; }

signals:

public slots:

protected:
    QMouseEvent*      event;

    bool _wasHeld;
    bool _isClick;
    bool _isDoubleClick;
};

#endif // KEVENT_H
