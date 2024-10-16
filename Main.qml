import QtQuick 2.15
import QtQuick.Controls 2.15
import QtDataVisualization 1.2

ApplicationWindow {
    visible: true
    width: 800
    height: 600

    Scatter3D {
        id: scatter

        anchors.fill: parent

        theme: Theme3D {
            labelBackgroundEnabled: false
            gridEnabled: true
        }

        // Tengelyek beállítása
        axisX: ValueAxis3D {
            title: "X"
            min: -10
            max: 10
        }
        axisY: ValueAxis3D {
            title: "Y"
            min: -10
            max: 10
        }
        axisZ: ValueAxis3D {
            title: "Z"
            min: -10
            max: 10
        }

        Scatter3DSeries {
            // Adatsorok meghatározása
            ItemModelScatterDataProxy {
                itemModel: ListModel {
                    // Adatok pontként való hozzáadása
                    ListElement { x: -5; y: 0; z: 5 }
                    ListElement { x: 0; y: 2; z: -3 }
                    ListElement { x: 3; y: 7; z: 2 }
                    ListElement { x: 6; y: 5; z: -6 }
                    ListElement { x: 1; y: -4; z: 8 }
                }
                xPosRole: "x"
                yPosRole: "y"
                zPosRole: "z"
            }
            baseColor: "blue"
        }
    }
}
