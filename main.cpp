#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "CsvReader.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<CsvReader>("scatterplot.csvreader", 1, 0, "CsvReader");

    const QUrl url(QStringLiteral("qrc:/scatterplot/Main.qml"));
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
