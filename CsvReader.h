#ifndef CSVREADER_H
#define CSVREADER_H

#include <QObject>
#include <QVariant>
#include <QList>
#include <QVariantMap>

class CsvReader : public QObject {
    Q_OBJECT

public:
    explicit CsvReader(QObject *parent = nullptr);

    Q_INVOKABLE QList<QVariantMap> readCsvSample(const QString &filepath);

signals:
    void dataRead(QList<QVariantMap> data);
};

#endif // CSVREADER_H
