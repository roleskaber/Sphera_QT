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
    QCommandLineParser parser;
    parser.setApplicationDescription("Сфера");
    parser.addHelpOption();
    parser.addVersionOption();
    parser.addPositionalArgument("url", "The URL(s) to open.");
    parser.process(app);


    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    const QUrl url(QStringLiteral("qrc:/Main.qml"));

    if (!parser.positionalArguments().isEmpty()) {
        QUrl source = QUrl::fromUserInput(parser.positionalArguments().at(0), QDir::currentPath());
        QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                         &engine, [source](QObject *object, const QUrl &) {
                             qDebug() << "setting source";
                             object->setProperty("source", source);
                         });
    }


    engine.loadFromModule("Sphera", "Main");

    return app.exec();
}
