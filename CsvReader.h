#ifndef CSVREADER_H
#define CSVREADER_H

#include <QObject>
#include <QList>
#include <QVariantMap>
#include <QString>

class CsvReader : public QObject {
    Q_OBJECT

public:
    explicit CsvReader(QObject *parent = nullptr);

    Q_INVOKABLE QList<QVariantMap> readCsvSample(const QString &filepath);
    Q_INVOKABLE QList<QVariantMap> readCsv(const QString &filepath);

signals:
    void dataRead(QList<QVariantMap> data);
};

#endif // CSVREADER_H
