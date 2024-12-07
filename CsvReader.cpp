#include "CsvReader.h"
#include <QFile>
#include <QTextStream>
#include <QStringList>
#include <QDebug>

CsvReader::CsvReader(QObject *parent) : QObject(parent) {}

QList<QVariantMap> CsvReader::readCsvSample(const QString &filepath) {
    QList<QVariantMap> dummyData;

    QVariantMap map1;
    map1["x"] = -5;
    map1["y"] = 0;
    map1["z"] = 5;
    map1["name"] = "Point A";
    map1["image"] = "001_fat.png";
    dummyData.append(map1);

    QVariantMap map2;
    map2["x"] = 0;
    map2["y"] = 2;
    map2["z"] = -3;
    map2["name"] = "Point B";
    map2["image"] = "002_fat.png";
    dummyData.append(map2);

    return dummyData;
}

QList<QVariantMap> CsvReader::readCsv(const QString &filepath) {
    QList<QVariantMap> dataList;

    QFile file(filepath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Failed to open file:" << filepath;
        return dataList;
    }

    QTextStream stream(&file);

    QStringList headers;
    if (!stream.atEnd()) {
        QString headerLine = stream.readLine();
        headers = headerLine.split(',');
    }

    while (!stream.atEnd()) {
        QString line = stream.readLine();
        QStringList values = line.split(',');

        if (values.size() == headers.size()) {
            QVariantMap map;
            for (int i = 0; i < headers.size(); ++i) {
                QString key = headers[i].trimmed();
                QString value = values[i].trimmed();

                bool isNumeric = false;
                double numericValue = value.toDouble(&isNumeric);

                if (isNumeric) {
                    map[key] = numericValue;
                } else {
                    map[key] = value;
                }
            }
            dataList.append(map);
        }
    }

    file.close();
    return dataList;
}
