import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphs

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    color: "black"

    Flow {
        anchors.fill: parent
        spacing: 0 // Nincs távolság a négyzetek között

        // Felső rész: Diagramot tartalmazó Rectangle
        Rectangle {
            id: diagramRect
            color: "#202020" // szürke háttér a kontraszt miatt

            // Szélesség és magasság beállítása
            width: (scatterSeries.selectedItem < 0 ? parent.width : (parent.width > parent.height ? parent.width * 0.6 : parent.width))
            height: (scatterSeries.selectedItem < 0 ? parent.height : (parent.width > parent.height ? parent.height : parent.height * 0.6))

            // Diagram beállításai
            Scatter3D {
                id: scatter
                anchors.fill: parent

                Scatter3DSeries {
                    id: scatterSeries
                    ItemModelScatterDataProxy {
                        itemModel: scatterDataModel // Hivatkozás a külön ListModel-ra
                        xPosRole: "x"
                        yPosRole: "y"
                        zPosRole: "z"
                    }

                    baseColor: "blue"

                    // Választott pont eseményének kezelése
                    onSelectedItemChanged: {
                        if (selectedItem >= 0) {
                            var item = scatterDataModel.get(selectedItem); // Kérjük le az elemet a külön ListModel-ból
                            selectedName.text = "Name: " + item.name;
                            selectedCoords.text = "Coordinates: (" + item.x + ", " + item.y + ", " + item.z + ")";
                            selectedImage.source = "file:///home/kecyke/Letöltések/images/" + item.image; // Kép betöltése
                        } else {
                            selectedName.text = "Name: None";
                            selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                            selectedImage.source = ""; // Ha nincs kiválasztva pont, akkor nincs kép
                        }
                    }
                }
            }
        }

        // Alsó rész: Adatok és kép megjelenítésére szolgáló Rectangle
        Rectangle {
            id: dataRect
            color: "#303030" // sötétszürke háttér

            // Szélesség és magasság beállítása
            width: (scatterSeries.selectedItem < 0 ? 0 : (parent.width > parent.height ? parent.width * 0.4 : parent.width))
            height: (scatterSeries.selectedItem < 0 ? 0 : (parent.width > parent.height ? parent.height : parent.height * 0.4))

            visible: scatterSeries.selectedItem >= 0 // Csak látható, ha van kiválasztott elem

            Column {
                anchors.fill: parent

                // Kép szekció (80%)
                Rectangle {
                    width: parent.width
                    height: parent.height * 0.8 // Kép 80%-os magassága
                    color: "#000000"

                    Image {
                        id: selectedImage
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        visible: scatterSeries.selectedItem >= 0 // Csak látható, ha van kiválasztott elem
                    }
                }

                // Adatok szekció (20%)
                Rectangle {
                    width: parent.width
                    height: parent.height * 0.2 // Adatok 20%-os magassága
                    color: "#404040" // Sötétebb háttér az adatoknak

                    Column {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            id: selectedName
                            text: "Name: None"
                            color: "white"
                            font.pixelSize: 18
                            visible: scatterSeries.selectedItem >= 0 // Csak látható, ha van kiválasztott elem
                        }

                        Text {
                            id: selectedCoords
                            text: "Coordinates: (N/A, N/A, N/A)"
                            color: "white"
                            font.pixelSize: 18
                            visible: scatterSeries.selectedItem >= 0 // Csak látható, ha van kiválasztott elem
                        }
                    }
                }
            }
        }

        // A külön ListModel definiálása
        ListModel {
            id: scatterDataModel
            ListElement { x: -5; y: 0; z: 5; name: "Point A"; image: "001_fat.png" }
            ListElement { x: 0; y: 2; z: -3; name: "Point B"; image: "002_fat.png" }
            ListElement { x: 3; y: 7; z: 2; name: "Point C"; image: "003_fat.png" }
            ListElement { x: 6; y: 5; z: -6; name: "Point D"; image: "004_fat.png" }
            ListElement { x: 1; y: -4; z: 8; name: "Point E"; image: "005_fat.png" }
        }
    }
}
