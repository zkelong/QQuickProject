#ifndef COLORMAKER_H
#define COLORMAKER_H

#include <QObject>
#include <QColor>

class ColorMaker : public QObject   //不加public，出现：QObject is an inaccesible base of 'ColorMaker'
{
    Q_OBJECT
    Q_ENUMS(GenerateAlgorithm)

    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)  //元系统，添加属性：color--可读；可写setColor;改变有信号colorChanged
    Q_PROPERTY(QColor timeColor READ timeColor) //timerColor: 可读
public:
    ColorMaker(QObject *parent = 0);
    ~ColorMaker();

    enum GenerateAlgorithm{
        RandomRGB,
        RandomRed,
        RandomGreen,
        RandomBlue,
        LinearIncrease
    };

    QColor color() const;
        void setColor(const QColor & color);
        QColor timeColor() const;

    Q_INVOKABLE GenerateAlgorithm algorithm() const;
    Q_INVOKABLE void setAlgorithm(GenerateAlgorithm algorithm);

signals:    //信号--可以在qml中使用
    void colorChanged(const QColor & color);
    void currentTime(const QString &strTime);
public slots:   //槽--可以在qml中使用
    void start();
    void stop();


protected:
    void timerEvent(QTimerEvent *e);

private:
    GenerateAlgorithm m_algorithm;
    QColor m_currentColor;
    int m_nColorTimer;
};

#endif // COLORMAKER_H


/**
将一个类或对象导入到QML中：
1.从 QObject 或 QObject 的派生类继承
2.使用 Q_OBJECT 宏

*/
/*
一旦你使用 Q_INVOKABLE 将某个方法注册到元对象系统中，
    在 QML 中就可以用 ${Object}.${method} 来访问
colorMaker 的 main.qml 中有使用 algorithm() 和 setAlgorithm() 的 QML 代码
 */

/*
如果你要导出的类定义了想在 QML 中使用枚举类型，可以使用 Q_ENUMS 宏将该枚举注册到元对象系统中。
    ColorMaker 类定义了 GenerateAlgorithm 枚举类型，支持 RandomRGB / RandomRed 等颜色生成算法

    一旦你使用 Q_ENUMS 宏注册了你的枚举类型，在 QML 中就可以用 ${CLASS_NAME}.${ENUM_VALUE} 的形式来访问，比如 ColorMaker.LinearIncrease

    Q_PROPERTY 宏用来定义可通过元对象系统访问的属性，通过它定义的属性，可以在 QML 中访问、修改，也可以在属性变化时发射特定的信号。要想使用 Q_PROPERTY 宏，你的类必须是 QObject 的后裔，必须在类首使用 Q_OBJECT 宏。


    Q_PROPERTY 宏的原型
    Q_PROPERTY(type name
               (READ getFunction [WRITE setFunction] |
                MEMBER memberName [(READ getFunction | WRITE setFunction)])
               [RESET resetFunction]
               [NOTIFY notifySignal]
               [REVISION int]
               [DESIGNABLE bool]
               [SCRIPTABLE bool]
               [STORED bool]
               [USER bool]
               [CONSTANT]
               [FINAL])  //不是所有的选项都必须设定，看一个最简短的属性声明：

 其实我们在实际使用中，很少能够用全 Q_PROPERTY 的所有选项，就往 QML 导出类这种场景来说，比较常用的是 READ / WRITE / NOTIFY 三个选项。我们来看看都是什么含义。

    READ 标记，如果你没有为属性指定 MEMBER 标记，则 READ 标记必不可少；声明一个读取属性的函数，该函数一般没有参数，返回定义的属性。
    WRITE 标记，可选配置。声明一个设定属性的函数。它指定的函数，只能有一个与属性类型匹配的参数，必须返回 void 。
    NOTIFY 标记，可选配置。给属性关联一个信号（该信号必须是已经在类中声明过的），当属性的值发生变化时就会触发该信号。信号的参数，一般就是你定义的属性。
*/
/*
注册一个 QML 中可用的类型,大概可以分四步：
1.实现 C++ 类
2.注册 QML 类型
3.在 QML 中导入类型
4.在 QML 创建由 C++ 导出的类型的实例并使用
*/
/*
 * 注册 QML 类型
    要注册一个 QML 类型，有多种方法可用，如 qmlRegisterSingletonType() 用来注册一个单例类型， qmlRegisterType() 注册一个非单例的类型， qmlRegisterTypeNotAvailable() 注册一个类型用来占位， qmlRegisterUncreatableType() 通常用来注册一个具有附加属性的附加类型
*/
/*
 template<typename T>
    int qmlRegisterType(const char *uri, int versionMajor, int versionMinor, const char *qmlName);

    template<typename T, int metaObjectRevision>
    int qmlRegisterType(const char *uri, int versionMajor, int versionMinor, const char *qmlName);
前一个原型一般用来注册一个新类型，而后一个可以为特定的版本注册类型。后面这个牵涉到 Qt Quick 的类型和版本机制，三言两语不能尽述，咱们单说前一个原型的使用。要使用 qmlRegisterType 需要包含 QtQml 头文件。
    先说模板参数 typename ，它就是你实现的 C++ 类的类名。
    qmlRegisterType() 的第一个参数 uri ，让你指定一个唯一的包名，类似 Java 中的那种，一是用来避免名字冲突，而是可以把多个相关类聚合到一个包中方便引用。比如我们常写这个语句 "import QtQuick.Controls 1.1" ，其中的 "QtQuick.Controls" 就是包名 uri ，而 1.1 则是版本，是 versionMajor 和 versionMinor 的组合。 qmlName 则是 QML 中可以使用的类名。
*/
