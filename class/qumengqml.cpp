#include "qumengqml.h"
#include "../libs/UmengQt/src/QUmeng.h"

QUmengQml::QUmengQml()
{

}

QUmengQml::~QUmengQml()
{

}

//添加推送别名
void QUmengQml :: addAlias(QString name)
{
    qDebug() << "addalias:" << name;
    QUmeng::ReqCallback callback = [this](std::shared_ptr<QError> error){
        if (error){
            qDebug() << "addAlias whis error:" << QString(error->message.c_str());
        } else {
            qDebug() << "addAlias scuess";
        }
    };
    QUmeng::instance()->addAlias(name.toStdString(),"",callback);
}

void QUmengQml :: removeAlias(QString name)
{
    QUmeng::ReqCallback callback = [this](std::shared_ptr<QError> error){
        if (error){
            qDebug() << "removeAlias whis error:" << QString(error->message.c_str());
        } else {
            qDebug() << "removeAlias scuess";
        }
    };
    QUmeng::instance()->removeAlias(name.toStdString(),"", callback);
}

void QUmengQml::presentSnsIconSheetView(QString shareText, QString url, QString shareImage, QList<int> snsNames)
{
   // qDebug() << "presentSnsIconSheetView:" << shareText << shareImage << snsNames;
    QUmeng::ReqCallback callback = [this](std::shared_ptr<QError> error){
        if (error){
            emit this->shareFinished(error->code, error->message.c_str());
        } else {
            emit this->shareFinished(0,"");
        }
    };

    std::list<int> list = snsNames.toStdList();
    QUmeng::instance()->presentSnsIconSheetView(shareText.toStdString(),url.toStdString(), shareImage.toStdString(), list,callback);
}


void QUmengQml:: postSNSWithTypes(enum _QUMengShare platformType, QString content, QString url,QString imagePath, QString urlResource)
{
    qDebug() << content << url << imagePath << urlResource;
    QUmeng::ReqCallback callback = [this](std::shared_ptr<QError> error){
        if (error){
            emit this->shareFinished(error->code, error->message.c_str());
        } else {
            emit this->shareFinished(0,"");
        }
    };

    QUmeng::instance()->postSNSWithTypes(QUmeng::QUMengShare(platformType), content.toStdString(),url.toStdString(), imagePath.toStdString(), urlResource.toStdString(), callback);
}
