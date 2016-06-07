#ifndef KWINDOW_H
#define KWINDOW_H

#include <QQuickWindow>
#include <QQuickItem>


class KWindow : public QQuickWindow
{
    Q_OBJECT
public:
    KWindow(QWindow *parent = 0);

Q_SIGNALS:
    void afterSynchronizing();
    void activeFocusItemChanged(QQuickItem* activeFocusItem);
    void afterAnimating();
    void sceneGraphAboutToStop();


public slots:

protected slots:
    void p_activeFocusItemChanged();

protected:
    virtual void keyPressEvent(QKeyEvent *);
    virtual void keyReleaseEvent(QKeyEvent *);
    bool event(QEvent *);

private:
    bool        m_mousePressed;
};

//Q_DECLARE_METATYPE(KWindow *)

#endif // KWINDOW_H
