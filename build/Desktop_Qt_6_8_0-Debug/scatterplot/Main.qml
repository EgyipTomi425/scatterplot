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
        spacing: 0

        Rectangle {
            id: diagramRect
            color: "#202020"
            width: (scatterSeries.selectedItem < 0 ? parent.width : (parent.width > parent.height ? parent.width * 0.6 : parent.width))
            height: (scatterSeries.selectedItem < 0 ? parent.height : (parent.width > parent.height ? parent.height : parent.height * 0.6))

            Flow {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    width: parent.width
                    height: parent.height * 0.1
                    color: "#303030"
                }

                Scatter3D {
                    id: scatter
                    width: parent.width
                    height: parent.height * 0.9

                    Scatter3DSeries {
                        id: scatterSeries
                        ItemModelScatterDataProxy {
                            itemModel: scatterDataModel
                            xPosRole: "x"
                            yPosRole: "y"
                            zPosRole: "z"
                        }

                        baseColor: "blue"

                        onSelectedItemChanged: {
                            if (selectedItem >= 0) {
                                var item = scatterDataModel.get(selectedItem)
                                selectedName.text = "Name: " + item.name
                                selectedCoords.text = "Coordinates: (" + item.x + ", " + item.y + ", " + item.z + ")"
                                selectedImage.source = "file:///home/kecyke/Letöltések/images/" + item.image
                            } else {
                                selectedName.text = "Name: None"
                                selectedCoords.text = "Coordinates: (N/A, N/A, N/A)"
                                selectedImage.source = ""
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: dataRect
            color: "#303030"
            width: (scatterSeries.selectedItem < 0 ? 0 : (parent.width > parent.height ? parent.width * 0.4 : parent.width))
            height: (scatterSeries.selectedItem < 0 ? 0 : (parent.width > parent.height ? parent.height : parent.height * 0.4))
            visible: scatterSeries.selectedItem >= 0

            Column {
                anchors.fill: parent

                Rectangle {
                    width: parent.width
                    height: parent.height * 0.8
                    color: "#000000"

                    Image {
                        id: selectedImage
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        visible: scatterSeries.selectedItem >= 0
                    }
                }

                Rectangle {
                    width: parent.width
                    height: parent.height * 0.2
                    color: "#404040"

                    Column {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            id: selectedName
                            text: "Name: None"
                            color: "white"
                            font.pixelSize: 18
                            visible: scatterSeries.selectedItem >= 0
                        }

                        Text {
                            id: selectedCoords
                            text: "Coordinates: (N/A, N/A, N/A)"
                            color: "white"
                            font.pixelSize: 18
                            visible: scatterSeries.selectedItem >= 0
                        }
                    }
                }
            }
        }

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
