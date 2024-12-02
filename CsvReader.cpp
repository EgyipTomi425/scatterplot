#include "CsvReader.h"

CsvReader::CsvReader(QObject *parent) : QObject(parent) {}

QList<QVariantMap> CsvReader::readCsvSample(const QString &filepath) {
    // Tesztadat visszaadása
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
