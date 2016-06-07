#include "kapplication.h"
#include "qkit.h"
#include "application_state.h"

#ifdef Q_QDOC
KApplication::KApplication(int &argc, char **argv):QApplication(argc,argv)
{
}
#else
KApplication::KApplication(int &argc, char **argv, int flag):QGuiApplication(argc,argv,flag)
{

}

#endif

int KApplication::exec()
{
    int ret = QGuiApplication::exec();

    EmitExit();
    QKit::instance()-> cleanRunTimeCache();
    return ret;
}
