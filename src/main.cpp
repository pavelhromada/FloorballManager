/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#include <QApplication>
#include "floorballmanager.h"

#ifdef Q_OS_ANDROID
#   include <QtAndroid>
#endif

#include <QStringView>

int main( int argc, char *argv[] )
{
    QCoreApplication::setAttribute( Qt::AA_EnableHighDpiScaling );
    QApplication app( argc, argv );

    FloorballManager manager;

    if (!manager.start())
        return -1;

#ifdef Q_OS_ANDROID
    QtAndroid::hideSplashScreen();
#endif

    return app.exec();
}
