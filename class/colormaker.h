#ifndef COLORMAKER_H
#define COLORMAKER_H

#include <QObject>
#include <QColor>

class ColorMaker : public QObject   //����public�����֣�QObject is an inaccesible base of 'ColorMaker'
{
    Q_OBJECT
    Q_ENUMS(GenerateAlgorithm)

    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)  //Ԫϵͳ��������ԣ�color--�ɶ�����дsetColor;�ı����ź�colorChanged
    Q_PROPERTY(QColor timeColor READ timeColor) //timerColor: �ɶ�
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

signals:    //�ź�--������qml��ʹ��
    void colorChanged(const QColor & color);
    void currentTime(const QString &strTime);
public slots:   //��--������qml��ʹ��
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
��һ���������뵽QML�У�
1.�� QObject �� QObject ��������̳�
2.ʹ�� Q_OBJECT ��

*/
/*
һ����ʹ�� Q_INVOKABLE ��ĳ������ע�ᵽԪ����ϵͳ�У�
    �� QML �оͿ����� ${Object}.${method} ������
colorMaker �� main.qml ����ʹ�� algorithm() �� setAlgorithm() �� QML ����
 */

/*
�����Ҫ�������ඨ�������� QML ��ʹ��ö�����ͣ�����ʹ�� Q_ENUMS �꽫��ö��ע�ᵽԪ����ϵͳ�С�
    ColorMaker �ඨ���� GenerateAlgorithm ö�����ͣ�֧�� RandomRGB / RandomRed ����ɫ�����㷨

    һ����ʹ�� Q_ENUMS ��ע�������ö�����ͣ��� QML �оͿ����� ${CLASS_NAME}.${ENUM_VALUE} ����ʽ�����ʣ����� ColorMaker.LinearIncrease

    Q_PROPERTY �����������ͨ��Ԫ����ϵͳ���ʵ����ԣ�ͨ������������ԣ������� QML �з��ʡ��޸ģ�Ҳ���������Ա仯ʱ�����ض����źš�Ҫ��ʹ�� Q_PROPERTY �꣬���������� QObject �ĺ��ᣬ����������ʹ�� Q_OBJECT �ꡣ


    Q_PROPERTY ���ԭ��
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
               [FINAL])  //�������е�ѡ������趨����һ�����̵�����������

 ��ʵ������ʵ��ʹ���У������ܹ���ȫ Q_PROPERTY ������ѡ����� QML ���������ֳ�����˵���Ƚϳ��õ��� READ / WRITE / NOTIFY ����ѡ���������������ʲô���塣

    READ ��ǣ������û��Ϊ����ָ�� MEMBER ��ǣ��� READ ��Ǳز����٣�����һ����ȡ���Եĺ������ú���һ��û�в��������ض�������ԡ�
    WRITE ��ǣ���ѡ���á�����һ���趨���Եĺ�������ָ���ĺ�����ֻ����һ������������ƥ��Ĳ��������뷵�� void ��
    NOTIFY ��ǣ���ѡ���á������Թ���һ���źţ����źű������Ѿ��������������ģ��������Ե�ֵ�����仯ʱ�ͻᴥ�����źš��źŵĲ�����һ������㶨������ԡ�
*/
/*
ע��һ�� QML �п��õ�����,��ſ��Է��Ĳ���
1.ʵ�� C++ ��
2.ע�� QML ����
3.�� QML �е�������
4.�� QML ������ C++ ���������͵�ʵ����ʹ��
*/
/*
 * ע�� QML ����
    Ҫע��һ�� QML ���ͣ��ж��ַ������ã��� qmlRegisterSingletonType() ����ע��һ���������ͣ� qmlRegisterType() ע��һ���ǵ��������ͣ� qmlRegisterTypeNotAvailable() ע��һ����������ռλ�� qmlRegisterUncreatableType() ͨ������ע��һ�����и������Եĸ�������
*/
/*
 template<typename T>
    int qmlRegisterType(const char *uri, int versionMajor, int versionMinor, const char *qmlName);

    template<typename T, int metaObjectRevision>
    int qmlRegisterType(const char *uri, int versionMajor, int versionMinor, const char *qmlName);
ǰһ��ԭ��һ������ע��һ�������ͣ�����һ������Ϊ�ض��İ汾ע�����͡��������ǣ�浽 Qt Quick �����ͺͰ汾���ƣ��������ﲻ�ܾ��������ǵ�˵ǰһ��ԭ�͵�ʹ�á�Ҫʹ�� qmlRegisterType ��Ҫ���� QtQml ͷ�ļ���
    ��˵ģ����� typename ����������ʵ�ֵ� C++ ���������
    qmlRegisterType() �ĵ�һ������ uri ������ָ��һ��Ψһ�İ��������� Java �е����֣�һ�������������ֳ�ͻ�����ǿ��԰Ѷ�������ۺϵ�һ�����з������á��������ǳ�д������ "import QtQuick.Controls 1.1" �����е� "QtQuick.Controls" ���ǰ��� uri ���� 1.1 ���ǰ汾���� versionMajor �� versionMinor ����ϡ� qmlName ���� QML �п���ʹ�õ�������
*/
