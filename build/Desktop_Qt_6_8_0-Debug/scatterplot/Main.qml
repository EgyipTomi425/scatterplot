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
                        } else {
                            selectedName.text = "Name: None";
                            selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                        }
                    }
                }
            }
        }

        // Alsó rész: Adatok megjelenítésére szolgáló Rectangle
        Rectangle {
            id: dataRect
            color: "#303030" // sötétszürke háttér

            // Szélesség és magasság beállítása
            width: (scatterSeries.selectedItem < 0 ? 0 : (parent.width > parent.height ? parent.width * 0.4 : parent.width))
            height: (scatterSeries.selectedItem < 0 ? 0 : (parent.width > parent.height ? parent.height : parent.height * 0.4))

            //visible: scatterSeries.selectedItem >= 0 // Csak látható, ha van kiválasztott elem

            Column {
                anchors.centerIn: parent
                spacing: 10

                Text {
                    id: selectedName
                    text: "Name: None"
                    color: "white"
                    font.pixelSize: 18
                    //visible: scatterSeries.selectedItem >= 0 // Csak látható, ha van kiválasztott elem
                }

                Text {
                    id: selectedCoords
                    text: "Coordinates: (N/A, N/A, N/A)"
                    color: "white"
                    font.pixelSize: 18
                    //visible: scatterSeries.selectedItem >= 0 // Csak látható, ha van kiválasztott elem
                }
            }
        }

        // A külön ListModel definiálása
        ListModel {
            id: scatterDataModel
            ListElement { x: -5; y: 0; z: 5; name: "Point A" }
            ListElement { x: 0; y: 2; z: -3; name: "Point B" }
            ListElement { x: 3; y: 7; z: 2; name: "Point C" }
            ListElement { x: 6; y: 5; z: -6; name: "Point D" }
            ListElement { x: 1; y: -4; z: 8; name: "Point E" }
        }
    }
}
