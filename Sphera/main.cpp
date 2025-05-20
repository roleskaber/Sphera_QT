#include <QCommandLineParser>
#include <QDir>
#include <QGuiApplication>
#include <QQmlApplicationEngine>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);


    QCoreApplication::setApplicationName("Sphera");
    QCoreApplication::setOrganizationName("MRC");
    QCoreApplication::setApplicationVersion(QT_VERSION_STR);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    const QUrl url(QStringLiteral("qrc:/Main.qml"));
    engine.loadFromModule("Sphera", "Main");

    return app.exec();
}
