import QtQuick
import QtQuick.Controls
import QtGraphs
import QtQuick.Dialogs
import scatterplot.csvreader

ApplicationWindow {
    visible: true
    width: 1920
    height: 1080
    color: "black"

    CsvReader {
        id: csvReader
    }

    property var scatterDataModel: ListModel {}
    property var uniqueValues: []
    property var groupedData: []

    property var scatterPlotMask: [1,1,1,1,1,1,1,1,1,1]

    ListModel {
        id: scatterDataModel
    }

    ListModel {
        id: colorMappings
    }

    Flow {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: diagramRect
            color: "#202020"
            width: (/*scatterSeries.selectedItem < 0 ? parent.width : */(parent.width > parent.height ? parent.width * 0.6 : parent.width))
            height: (/*scatterSeries.selectedItem < 0 ? parent.height : */(parent.width > parent.height ? parent.height : parent.height * 0.6))

            Flow {
                anchors.fill: parent
                spacing: 0

                Row {
                    width: parent.width
                    height: parent.height * 0.1

                    Rectangle {
                        id: checkboxfieldRect
                        width: (parent.parent.width > parent.parent.height ? parent.width - 3 * parent.height : parent.width - 0.5 * parent.height * 3)
                        height: parent.height
                        color: "#303030"

                        Flow {
                            id: checkboxLayout
                            anchors.fill: parent
                            spacing: 10
                        }
                    }

                    ComboBox {
                        id: coloringButton
                        width: (parent.parent.width > parent.parent.height ? parent.height : 0.5 * parent.height)
                        height: parent.height
                        model: ListModel {}

                        onCurrentIndexChanged: {
                            if (currentIndex >= 0) {
                                var selectedAttribute = coloringButton.model.get(currentIndex).text;
                                uniqueValues = getUniqueValuesForAttribute(selectedAttribute);
                                colorPickerPopup.open();
                            }
                        }
                    }

                    Button {
                        id: readerButton
                        text: "Load Test Data"
                        width: (parent.parent.width > parent.parent.height ? parent.height : 0.5 * parent.height)
                        height: parent.height
                        onClicked: {
                            var testData = csvReader.readCsv("/home/kecyke/Letöltések/project/data_with_bmi_and_category.csv");
                            scatterDataModel.clear();
                            testData.forEach(function (item, index) {
                                scatterDataModel.append(item);
                                console.log("Item " + index + ": " + JSON.stringify(scatterDataModel.get(index)));
                            });
                            createCheckboxesForNumericAttributes();
                            updateComboBoxModel();
                        }
                    }

                    Button {
                        id: updateButton
                        text: "Update Scatter Plot"
                        width: parent.height
                        height: parent.height
                        onClicked: {
                            var selectedAttributes = getSelectedAttributes();
                            var allSelected = scatterPlotMask.every(function(value) {
                                    return value === 1;
                                });
                            if (selectedAttributes.length === 3) {
                                scatter.orthoProjection = false;

                                if (allSelected) {
                                    scatterDataProxy.xPosRole = selectedAttributes[0];
                                    scatterDataProxy.yPosRole = selectedAttributes[1];
                                    scatterDataProxy.zPosRole = selectedAttributes[2];
                                }

                                for (var i = 0; i < scatterPlotMask.length; i++) {
                                    if (scatterPlotMask[i] === 1) {
                                        switch(i) {
                                            case 0:
                                                scatterDataProxy0.xPosRole = selectedAttributes[0];
                                                scatterDataProxy0.yPosRole = selectedAttributes[1];
                                                scatterDataProxy0.zPosRole = selectedAttributes[2];
                                                break;
                                            case 1:
                                                scatterDataProxy1.xPosRole = selectedAttributes[0];
                                                scatterDataProxy1.yPosRole = selectedAttributes[1];
                                                scatterDataProxy1.zPosRole = selectedAttributes[2];
                                                break;
                                            case 2:
                                                scatterDataProxy2.xPosRole = selectedAttributes[0];
                                                scatterDataProxy2.yPosRole = selectedAttributes[1];
                                                scatterDataProxy2.zPosRole = selectedAttributes[2];
                                                break;
                                            case 3:
                                                scatterDataProxy3.xPosRole = selectedAttributes[0];
                                                scatterDataProxy3.yPosRole = selectedAttributes[1];
                                                scatterDataProxy3.zPosRole = selectedAttributes[2];
                                                break;
                                            case 4:
                                                scatterDataProxy4.xPosRole = selectedAttributes[0];
                                                scatterDataProxy4.yPosRole = selectedAttributes[1];
                                                scatterDataProxy4.zPosRole = selectedAttributes[2];
                                                break;
                                            case 5:
                                                scatterDataProxy5.xPosRole = selectedAttributes[0];
                                                scatterDataProxy5.yPosRole = selectedAttributes[1];
                                                scatterDataProxy5.zPosRole = selectedAttributes[2];
                                                break;
                                            case 6:
                                                scatterDataProxy6.xPosRole = selectedAttributes[0];
                                                scatterDataProxy6.yPosRole = selectedAttributes[1];
                                                scatterDataProxy6.zPosRole = selectedAttributes[2];
                                                break;
                                            case 7:
                                                scatterDataProxy7.xPosRole = selectedAttributes[0];
                                                scatterDataProxy7.yPosRole = selectedAttributes[1];
                                                scatterDataProxy7.zPosRole = selectedAttributes[2];
                                                break;
                                            case 8:
                                                scatterDataProxy8.xPosRole = selectedAttributes[0];
                                                scatterDataProxy8.yPosRole = selectedAttributes[1];
                                                scatterDataProxy8.zPosRole = selectedAttributes[2];
                                                break;
                                            case 9:
                                                scatterDataProxy9.xPosRole = selectedAttributes[0];
                                                scatterDataProxy9.yPosRole = selectedAttributes[1];
                                                scatterDataProxy9.zPosRole = selectedAttributes[2];
                                                break;
                                        }
                                    }
                                }

                                console.log("Updated Scatter3D with: " + selectedAttributes);
                            } else if (selectedAttributes.length === 2) {
                                scatter.orthoProjection = true;

                                scatterDataProxy.xPosRole = selectedAttributes[0];
                                scatterDataProxy.yPosRole = selectedAttributes[1];

                                scatterDataProxy0.xPosRole = selectedAttributes[0];
                                scatterDataProxy0.yPosRole = selectedAttributes[1];

                                scatterDataProxy1.xPosRole = selectedAttributes[0];
                                scatterDataProxy1.yPosRole = selectedAttributes[1];

                                scatterDataProxy2.xPosRole = selectedAttributes[0];
                                scatterDataProxy2.yPosRole = selectedAttributes[1];

                                scatterDataProxy3.xPosRole = selectedAttributes[0];
                                scatterDataProxy3.yPosRole = selectedAttributes[1];

                                scatterDataProxy4.xPosRole = selectedAttributes[0];
                                scatterDataProxy4.yPosRole = selectedAttributes[1];

                                scatterDataProxy5.xPosRole = selectedAttributes[0];
                                scatterDataProxy5.yPosRole = selectedAttributes[1];

                                scatterDataProxy6.xPosRole = selectedAttributes[0];
                                scatterDataProxy6.yPosRole = selectedAttributes[1];

                                scatterDataProxy7.xPosRole = selectedAttributes[0];
                                scatterDataProxy7.yPosRole = selectedAttributes[1];

                                scatterDataProxy8.xPosRole = selectedAttributes[0];
                                scatterDataProxy8.yPosRole = selectedAttributes[1];

                                scatterDataProxy9.xPosRole = selectedAttributes[0];
                                scatterDataProxy9.yPosRole = selectedAttributes[1];

                                console.log("Updated Scatter3D with two attributes.");
                            } else {
                                console.error("Please select exactly two or three attributes.");
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: parent.height * 0.9

                    Scatter3D {
                        id: scatter
                        width: parent.width
                        height: parent.height
                        aspectRatio: 1
                        horizontalAspectRatio: 1
                        orthoProjection: false

                        axisX {
                            id: xAxis
                            titleVisible: true
                            labelFormat: "%.2f"
                            labelAutoAngle: 90
                        }

                        axisY {
                            id: yAxis
                            titleVisible: true
                            labelFormat: "%.2f"
                            labelAutoAngle: 90
                        }

                        axisZ {
                            id: zAxis
                            titleVisible: true
                            labelFormat: "%.2f"
                            labelAutoAngle: 90
                        }

                        // Már nincs jobb ötletem, mert se dinamikusan, sem repeaterrel nem engedi kretálni...

                        Scatter3DSeries {
                            id: scatterSeries
                            ItemModelScatterDataProxy {
                                id: scatterDataProxy
                                itemModel: scatterDataModel
                                xPosRole: "x"
                                yPosRole: "y"
                                zPosRole: "z"
                            }
                            baseColor: "blue"
                            itemSize: 0.09

                            onSelectedItemChanged: {
                                if (selectedItem >= 0) {
                                    var item = scatterDataModel.get(selectedItem);
                                    var xAttr = scatterDataProxy.xPosRole;
                                    var yAttr = scatterDataProxy.yPosRole;
                                    var zAttr = scatterDataProxy.zPosRole;

                                    selectedName.text = "Name: " + (item.name || "N/A");
                                    selectedCoords.text = "Coordinates: \n" +
                                                          xAttr + ": " + (item[xAttr] || "N/A") + ", \n" +
                                                          yAttr + ": " + (item[yAttr] || "N/A") + ", \n" +
                                                          zAttr + ": " + (item[zAttr] || "N/A");
                                    selectedImage.source = "file:///home/kecyke/Letöltések/images/" + (item.id + "_fat.png" || "");
                                } else {
                                    selectedName.text = "Name: None";
                                    selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                                    selectedImage.source = "";
                                }
                            }
                        }

                        Scatter3DSeries {
                            id: scatterSeries0
                            ItemModelScatterDataProxy {
                                id: scatterDataProxy0
                                itemModel: scatterListModel0
                                xPosRole: "x"
                                yPosRole: "y"
                                zPosRole: "z"
                            }
                            itemSize: 0.1

                            onSelectedItemChanged: {
                                if (selectedItem >= 0) {
                                    var item = scatterListModel0.get(selectedItem);
                                    var xAttr = scatterDataProxy0.xPosRole;
                                    var yAttr = scatterDataProxy0.yPosRole;
                                    var zAttr = scatterDataProxy0.zPosRole;

                                    selectedName.text = "Name: " + (item.name || "N/A");
                                    selectedCoords.text = "Coordinates: \n" +
                                                          xAttr + ": " + (item[xAttr] || "N/A") + ", \n" +
                                                          yAttr + ": " + (item[yAttr] || "N/A") + ", \n" +
                                                          zAttr + ": " + (item[zAttr] || "N/A");
                                    selectedImage.source = "file:///home/kecyke/Letöltések/images/" + (item.id + "_fat.png" || "");
                                } else {
                                    selectedName.text = "Name: None";
                                    selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                                    selectedImage.source = "";
                                }
                            }
                        }

                        Scatter3DSeries {
                            id: scatterSeries1
                            ItemModelScatterDataProxy {
                                id: scatterDataProxy1
                                itemModel: scatterListModel1
                                xPosRole: "x"
                                yPosRole: "y"
                                zPosRole: "z"
                            }
                            itemSize: 0.1

                            onSelectedItemChanged: {
                                if (selectedItem >= 0) {
                                    var item = scatterListModel1.get(selectedItem);
                                    var xAttr = scatterDataProxy1.xPosRole;
                                    var yAttr = scatterDataProxy1.yPosRole;
                                    var zAttr = scatterDataProxy1.zPosRole;

                                    selectedName.text = "Name: " + (item.name || "N/A");
                                    selectedCoords.text = "Coordinates: \n" +
                                                          xAttr + ": " + (item[xAttr] || "N/A") + ", \n" +
                                                          yAttr + ": " + (item[yAttr] || "N/A") + ", \n" +
                                                          zAttr + ": " + (item[zAttr] || "N/A");
                                    selectedImage.source = "file:///home/kecyke/Letöltések/images/" + (item.id + "_fat.png" || "");
                                } else {
                                    selectedName.text = "Name: None";
                                    selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                                    selectedImage.source = "";
                                }
                            }
                        }

                        Scatter3DSeries {
                            id: scatterSeries2
                            ItemModelScatterDataProxy {
                                id: scatterDataProxy2
                                itemModel: scatterListModel2
                                xPosRole: "x"
                                yPosRole: "y"
                                zPosRole: "z"
                            }
                            itemSize: 0.1

                            onSelectedItemChanged: {
                                if (selectedItem >= 0) {
                                    var item = scatterListModel2.get(selectedItem);
                                    var xAttr = scatterDataProxy2.xPosRole;
                                    var yAttr = scatterDataProxy2.yPosRole;
                                    var zAttr = scatterDataProxy2.zPosRole;

                                    selectedName.text = "Name: " + (item.name || "N/A");
                                    selectedCoords.text = "Coordinates: \n" +
                                                          xAttr + ": " + (item[xAttr] || "N/A") + ", \n" +
                                                          yAttr + ": " + (item[yAttr] || "N/A") + ", \n" +
                                                          zAttr + ": " + (item[zAttr] || "N/A");
                                    selectedImage.source = "file:///home/kecyke/Letöltések/images/" + (item.id + "_fat.png" || "");
                                } else {
                                    selectedName.text = "Name: None";
                                    selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                                    selectedImage.source = "";
                                }
                            }
                        }

                        Scatter3DSeries {
                            id: scatterSeries3
                            ItemModelScatterDataProxy {
                                id: scatterDataProxy3
                                itemModel: scatterListModel3
                                xPosRole: "x"
                                yPosRole: "y"
                                zPosRole: "z"
                            }
                            itemSize: 0.1

                            onSelectedItemChanged: {
                                if (selectedItem >= 0) {
                                    var item = scatterListModel3.get(selectedItem);
                                    var xAttr = scatterDataProxy3.xPosRole;
                                    var yAttr = scatterDataProxy3.yPosRole;
                                    var zAttr = scatterDataProxy3.zPosRole;

                                    selectedName.text = "Name: " + (item.name || "N/A");
                                    selectedCoords.text = "Coordinates: \n" +
                                                          xAttr + ": " + (item[xAttr] || "N/A") + ", \n" +
                                                          yAttr + ": " + (item[yAttr] || "N/A") + ", \n" +
                                                          zAttr + ": " + (item[zAttr] || "N/A");
                                    selectedImage.source = "file:///home/kecyke/Letöltések/images/" + (item.id + "_fat.png" || "");
                                } else {
                                    selectedName.text = "Name: None";
                                    selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                                    selectedImage.source = "";
                                }
                            }
                        }

                        Scatter3DSeries {
                            id: scatterSeries4
                            ItemModelScatterDataProxy {
                                id: scatterDataProxy4
                                itemModel: scatterListModel4
                                xPosRole: "x"
                                yPosRole: "y"
                                zPosRole: "z"
                            }
                            itemSize: 0.1

                            onSelectedItemChanged: {
                                if (selectedItem >= 0) {
                                    var item = scatterListModel4.get(selectedItem);
                                    var xAttr = scatterDataProxy4.xPosRole;
                                    var yAttr = scatterDataProxy4.yPosRole;
                                    var zAttr = scatterDataProxy4.zPosRole;

                                    selectedName.text = "Name: " + (item.name || "N/A");
                                    selectedCoords.text = "Coordinates: \n" +
                                                          xAttr + ": " + (item[xAttr] || "N/A") + ", \n" +
                                                          yAttr + ": " + (item[yAttr] || "N/A") + ", \n" +
                                                          zAttr + ": " + (item[zAttr] || "N/A");
                                    selectedImage.source = "file:///home/kecyke/Letöltések/images/" + (item.id + "_fat.png" || "");
                                } else {
                                    selectedName.text = "Name: None";
                                    selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                                    selectedImage.source = "";
                                }
                            }
                        }

                        Scatter3DSeries {
                            id: scatterSeries5
                            ItemModelScatterDataProxy {
                                id: scatterDataProxy5
                                itemModel: scatterListModel5
                                xPosRole: "x"
                                yPosRole: "y"
                                zPosRole: "z"
                            }
                            itemSize: 0.1

                            onSelectedItemChanged: {
                                if (selectedItem >= 0) {
                                    var item = scatterListModel0.get(selectedItem);
                                    var xAttr = scatterDataProxy5.xPosRole;
                                    var yAttr = scatterDataProxy5.yPosRole;
                                    var zAttr = scatterDataProxy5.zPosRole;

                                    selectedName.text = "Name: " + (item.name || "N/A");
                                    selectedCoords.text = "Coordinates: \n" +
                                                          xAttr + ": " + (item[xAttr] || "N/A") + ", \n" +
                                                          yAttr + ": " + (item[yAttr] || "N/A") + ", \n" +
                                                          zAttr + ": " + (item[zAttr] || "N/A");
                                    selectedImage.source = "file:///home/kecyke/Letöltések/images/" + (item.id + "_fat.png" || "");
                                } else {
                                    selectedName.text = "Name: None";
                                    selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                                    selectedImage.source = "";
                                }
                            }
                        }

                        Scatter3DSeries {
                            id: scatterSeries6
                            ItemModelScatterDataProxy {
                                id: scatterDataProxy6
                                xPosRole: "x"
                                yPosRole: "y"
                                zPosRole: "z"
                            }
                            baseColor: groupedData[6].color || "red"
                            itemSize: 0.1

                            onSelectedItemChanged: {
                                if (selectedItem >= 0) {
                                    var item = scatterListModel6.get(selectedItem);
                                    var xAttr = scatterDataProxy6.xPosRole;
                                    var yAttr = scatterDataProxy6.yPosRole;
                                    var zAttr = scatterDataProxy6.zPosRole;

                                    selectedName.text = "Name: " + (item.name || "N/A");
                                    selectedCoords.text = "Coordinates: \n" +
                                                          xAttr + ": " + (item[xAttr] || "N/A") + ", \n" +
                                                          yAttr + ": " + (item[yAttr] || "N/A") + ", \n" +
                                                          zAttr + ": " + (item[zAttr] || "N/A");
                                    selectedImage.source = "file:///home/kecyke/Letöltések/images/" + (item.id + "_fat.png" || "");
                                } else {
                                    selectedName.text = "Name: None";
                                    selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                                    selectedImage.source = "";
                                }
                            }
                        }

                        Scatter3DSeries {
                            id: scatterSeries7
                            ItemModelScatterDataProxy {
                                id: scatterDataProxy7
                                itemModel: scatterListModel7
                                xPosRole: "x"
                                yPosRole: "y"
                                zPosRole: "z"
                            }
                            itemSize: 0.1

                            onSelectedItemChanged: {
                                if (selectedItem >= 0) {
                                    var item = scatterListModel7.get(selectedItem);
                                    var xAttr = scatterDataProxy7.xPosRole;
                                    var yAttr = scatterDataProxy7.yPosRole;
                                    var zAttr = scatterDataProxy7.zPosRole;

                                    selectedName.text = "Name: " + (item.name || "N/A");
                                    selectedCoords.text = "Coordinates: \n" +
                                                          xAttr + ": " + (item[xAttr] || "N/A") + ", \n" +
                                                          yAttr + ": " + (item[yAttr] || "N/A") + ", \n" +
                                                          zAttr + ": " + (item[zAttr] || "N/A");
                                    selectedImage.source = "file:///home/kecyke/Letöltések/images/" + (item.id + "_fat.png" || "");
                                } else {
                                    selectedName.text = "Name: None";
                                    selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                                    selectedImage.source = "";
                                }
                            }
                        }

                        Scatter3DSeries {
                            id: scatterSeries8
                            ItemModelScatterDataProxy {
                                id: scatterDataProxy8
                                itemModel: scatterListModel8
                                xPosRole: "x"
                                yPosRole: "y"
                                zPosRole: "z"
                            }
                            itemSize: 0.1

                            onSelectedItemChanged: {
                                if (selectedItem >= 0) {
                                    var item = scatterListModel8.get(selectedItem);
                                    var xAttr = scatterDataProxy8.xPosRole;
                                    var yAttr = scatterDataProxy8.yPosRole;
                                    var zAttr = scatterDataProxy8.zPosRole;

                                    selectedName.text = "Name: " + (item.name || "N/A");
                                    selectedCoords.text = "Coordinates: \n" +
                                                          xAttr + ": " + (item[xAttr] || "N/A") + ", \n" +
                                                          yAttr + ": " + (item[yAttr] || "N/A") + ", \n" +
                                                          zAttr + ": " + (item[zAttr] || "N/A");
                                    selectedImage.source = "file:///home/kecyke/Letöltések/images/" + (item.id + "_fat.png" || "");
                                } else {
                                    selectedName.text = "Name: None";
                                    selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                                    selectedImage.source = "";
                                }
                            }
                        }

                        Scatter3DSeries {
                            id: scatterSeries9
                            ItemModelScatterDataProxy {
                                id: scatterDataProxy9
                                itemModel: scatterListModel9
                                xPosRole: "x"
                                yPosRole: "y"
                                zPosRole: "z"
                            }
                            itemSize: 0.1

                            onSelectedItemChanged: {
                                if (selectedItem >= 0) {
                                    var item = scatterListModel9.get(selectedItem);
                                    var xAttr = scatterDataProxy9.xPosRole;
                                    var yAttr = scatterDataProxy9.yPosRole;
                                    var zAttr = scatterDataProxy9.zPosRole;

                                    selectedName.text = "Name: " + (item.name || "N/A");
                                    selectedCoords.text = "Coordinates: \n" +
                                                          xAttr + ": " + (item[xAttr] || "N/A") + ", \n" +
                                                          yAttr + ": " + (item[yAttr] || "N/A") + ", \n" +
                                                          zAttr + ": " + (item[zAttr] || "N/A");
                                    selectedImage.source = "file:///home/kecyke/Letöltések/images/" + (item.id + "_fat.png" || "");
                                } else {
                                    selectedName.text = "Name: None";
                                    selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                                    selectedImage.source = "";
                                }
                            }
                        }

                        // Már nincs jobb ötletem, mert se dinamikusan, sem repeaterrel nem engedi kretálni...
                    }

                    Slider {
                        width: 400
                        height: 50
                        anchors.top: scatter.top
                        anchors.right: scatter.right
                        anchors.margins: 10

                        stepSize: 0.01

                        onValueChanged: {
                            scatterSeries.itemSize = value*0.95;scatterSeries0.itemSize = value;scatterSeries1.itemSize = value;
                            scatterSeries2.itemSize = value;scatterSeries3.itemSize = value;scatterSeries4.itemSize = value;
                            scatterSeries5.itemSize = value;scatterSeries6.itemSize = value;scatterSeries7.itemSize = value;
                            scatterSeries8.itemSize = value;scatterSeries9.itemSize = value;
                        }
                    }

                }
            }
        }

        Rectangle {
            id: dataRect
            color: "#303030"
            width: (/*scatterSeries.selectedItem < 0 ? 0 : */(parent.width > parent.height ? parent.width * 0.4 : parent.width))
            height: (/*scatterSeries.selectedItem < 0 ? 0 : */(parent.width > parent.height ? parent.height : parent.height * 0.4))
            visible: true//scatterSeries.selectedItem >= 0

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
                        visible: true//scatterSeries.selectedItem >= 0
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
                            visible: true//scatterSeries.selectedItem >= 0
                        }

                        Text {
                            id: selectedCoords
                            text: "Coordinates: (N/A, N/A, N/A)"
                            color: "white"
                            font.pixelSize: 18
                            visible: true//scatterSeries.selectedItem >= 0
                        }
                    }
                }
            }
        }
    }

    ListModel {id: scatterListModel0}
    ListModel {id: scatterListModel1}
    ListModel {id: scatterListModel2}
    ListModel {id: scatterListModel3}
    ListModel {id: scatterListModel4}
    ListModel {id: scatterListModel5}
    ListModel {id: scatterListModel6}
    ListModel {id: scatterListModel7}
    ListModel {id: scatterListModel8}
    ListModel {id: scatterListModel9}

    function convertToListModel(dataArray, targetModel) {
        for (var i = 0; i < dataArray.length; i++) {
            var item = dataArray[i];

            var element = {};
            for (var key in item) {
                if (item[key] !== undefined) {
                    element[key] = item[key];
                }
            }

            targetModel.append(element);
        }

        for (var i = 0; i < targetModel.count; i++) {
            var element = targetModel.get(i);
            console.log("Elem " + i + ": " + JSON.stringify(element));
        }
    }

    function createCheckboxesForNumericAttributes() {
        checkboxLayout.children.forEach(function (child) {
            child.destroy();
        });

        if (scatterDataModel.count > 0) {
            var firstItem = scatterDataModel.get(0);
            var numericAttributes = [];

            for (var key in firstItem) {
                var value = firstItem[key];
                if (typeof value === 'number') {
                    numericAttributes.push(key);
                }
            }

            numericAttributes.forEach(function (attribute) {
                var newCheckbox = checkboxComponent.createObject(checkboxLayout, { text: attribute });
                if (newCheckbox) {
                    console.log("Checkbox created for: " + attribute);
                }
            });
        }
    }

    function setupScatterPlots() {
        try { convertToListModel(groupedData[0].data, scatterListModel0); scatterSeries0.baseColor=groupedData[0].color} catch (e) {}
        try { convertToListModel(groupedData[1].data, scatterListModel1); scatterSeries1.baseColor=groupedData[1].color} catch (e) {}
        try { convertToListModel(groupedData[2].data, scatterListModel2); scatterSeries2.baseColor=groupedData[2].color} catch (e) {}
        try { convertToListModel(groupedData[3].data, scatterListModel3); scatterSeries3.baseColor=groupedData[3].color} catch (e) {}
        try { convertToListModel(groupedData[4].data, scatterListModel4); scatterSeries4.baseColor=groupedData[4].color} catch (e) {}
        try { convertToListModel(groupedData[5].data, scatterListModel5); scatterSeries5.baseColor=groupedData[5].color} catch (e) {}
        try { convertToListModel(groupedData[6].data, scatterListModel6); scatterSeries6.baseColor=groupedData[6].color} catch (e) {}
        try { convertToListModel(groupedData[7].data, scatterListModel7); scatterSeries7.baseColor=groupedData[7].color} catch (e) {}
        try { convertToListModel(groupedData[8].data, scatterListModel8); scatterSeries8.baseColor=groupedData[8].color} catch (e) {}
        try { convertToListModel(groupedData[9].data, scatterListModel9); scatterSeries9.baseColor=groupedData[9].color} catch (e) {}
        createSummaryBox();
    }

    function createSummaryBox() {
        Qt.createQmlObject(
            `import QtQuick 2.15;
             Rectangle {
                 id: summaryBox;
                 width: parent.width / 5;
                 height: parent.height / 4.5;
                 color: "black";
                 anchors.right: parent.right;
                 anchors.bottom: parent.bottom;
                 border.color: "white";
                 border.width: 1;
                 clip: true;

                 ListModel {
                     id: summaryModel;
                     Component.onCompleted: {
                         groupedData.forEach((item) => {
                             append({
                                 name: item.name,
                                 color: item.color,
                                 itemCount: item.data.length
                             });
                         });
                     }
                 }

                 Column {
                     id: summaryContent;
                     spacing: 5;
                     anchors.fill: parent;
                     anchors.margins: 10;

                     Repeater {
                         model: summaryModel;

                         Row {
                             spacing: 10;
                             width: parent.width;
                             property int rowIndex: index

                             Rectangle {
                                 width: 20;
                                 height: 20;
                                 color: model.color;
                                 border.color: "white";
                                 border.width: 1;

                                 MouseArea {
                                     id: rowClickAreaRect;
                                     width: parent.width;
                                     height: parent.height;

                                     onClicked: {
                                         scatterPlotMask[rowIndex] = scatterPlotMask[rowIndex] === 1 ? 0 : 1;
                                         console.log(\`Row clicked: Index \${parent.parent.rowIndex} toggled to \${scatterPlotMask[parent.parent.rowIndex]}\`);
                                     }
                                 }
                             }

                             Text {
                                 text: model.name + " (" + model.itemCount + ") ";
                                 color: "white";
                                 font.pixelSize: 12;
                                 verticalAlignment: Text.AlignVCenter;

                                 MouseArea {
                                     id: rowClickAreaText;
                                     width: parent.width;
                                     height: parent.height;

                                     onClicked: {
                                         scatterPlotMask[rowIndex] = scatterPlotMask[rowIndex] === 1 ? 0 : 1;
                                         console.log(\`Row clicked: Index \${parent.parent.rowIndex} toggled to \${scatterPlotMask[parent.parent.rowIndex]}\`);
                                     }
                                 }
                             }
                         }
                     }
                 }
             }`,
            scatter,
            'summaryBox'
        );
    }

    function getSelectedAttributes() {
        var selectedAttributes = [];
        checkboxLayout.children.forEach(function (checkbox) {
            if (checkbox.checked) {
                selectedAttributes.push(checkbox.text);
            }
        });
        console.log(selectedAttributes);
        return selectedAttributes;
    }

    function getNonNumericAttributesFromModel() {
        var nonNumericAttributes = [];
        if (scatterDataModel.count > 0) {
            var firstItem = scatterDataModel.get(0);
            for (var key in firstItem) {
                var value = firstItem[key];
                if (typeof value !== 'number') {
                    nonNumericAttributes.push(key);
                }
            }
        }
        console.log("Non numeric attributes: " + nonNumericAttributes);
        return nonNumericAttributes;
    }

    function updateComboBoxModel() {
        coloringButton.model.clear();
        var nonNumericAttributes = getNonNumericAttributesFromModel();
        nonNumericAttributes.forEach(function (attribute) {
            coloringButton.model.append({ text: attribute });
        });
    }

    function getUniqueValuesForAttribute(attributeName) {
        var uniqueValues = new Set();
        for (var i = 0; i < scatterDataModel.count; i++) {
            var item = scatterDataModel.get(i);
            if (item[attributeName] !== undefined) {
                uniqueValues.add(item[attributeName]);
            }
        }
        console.log("Unique values for " + attributeName + ": " + Array.from(uniqueValues).join(", "));
        return Array.from(uniqueValues);
    }

    function randomColor() {
        // Generál egy véletlenszerű színt hexadecimális formában
        let r = Math.round(Math.random() * 256);
        let g = Math.round(Math.random() * 256);
        let b = Math.round(Math.random() * 256);
        return "#" + ((1 << 24) | (r << 16) | (g << 8) | b).toString(16).slice(1).toUpperCase();
    }

    function printColorPairs()
    {
        console.log("Name color pairs:");
        for (var i = 0; i < tempColorMappingsModel.count; i++) {
            var item = tempColorMappingsModel.get(i);
            console.log(item.name + ": " + item.color);
        }
    }

    function groupDataByAttributeWithColors(attributeName) {
        console.log("\nSelected attribute for grouping: " + attributeName);

        if (scatterDataModel.count === 0) {
            console.error("scatterDataModel is empty.");
            return;
        }
        if (colorMappings.count === 0) {
            console.error("colorMappings is empty.");
            return;
        }

        groupedData = [];

        for (let i = 0; i < colorMappings.count; i++) {
            let item = colorMappings.get(i);
            groupedData.push({
                name: item.name,
                color: item.color,
                data: []
            });
        }

        for (let j = 0; j < scatterDataModel.count; j++) {
            let dataItem = scatterDataModel.get(j);
            let value = dataItem[attributeName];
            if (value === undefined) {
                console.warn("Attribute not found in data item:", dataItem);
                continue;
            }

            let group = groupedData.find(group => group.name === value);
            if (group) {
                group.data.push(dataItem);
            } else {
                console.warn("No group found for value:", value);
            }
        }

        console.log("Grouped data updated:");
        console.log(JSON.stringify(groupedData, null, 2));

        console.log("Number of categories: " + groupedData.length);

        // Making visual plots
        setupScatterPlots();
    }


    Component {
        id: checkboxComponent
        CheckBox {
            text: "Attribute"
            checked: false
            font.pixelSize: Math.max(
                parent.width / 7 / Math.max(checkboxLayout.children.length, 1),
                parent.height / 7
            )
        }
    }

    ListModel {
        id: tempColorMappingsModel
    }

    function findColorByName(name) {
        for (let i = 0; i < tempColorMappingsModel.count; i++) {
            let item = tempColorMappingsModel.get(i);
            if (item.name === name) {
                return item.color;
            }
        }
        return null;
    }

    function randomizeColors() {
        for (let i = 0; i < tempColorMappingsModel.count; i++) {
            let item = tempColorMappingsModel.get(i);
            tempColorMappingsModel.set(i, {
                name: item.name,
                color: randomColor()
            });
        }
    }

    Popup {
        id: colorPickerPopup
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        width: parent.width / 2
        height: parent.height / 2

        Rectangle {
            width: parent.width
            height: parent.height
            color: "black"

            Flow {
                width: parent.width
                height: parent.height * 0.9
                spacing: 10

                Repeater {
                    model: uniqueValues
                    delegate: Item {
                        width: Math.max((parent.width - 20) / 5, 50)
                        height: Math.max((parent.height - 20) / 5, 100)

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "transparent"

                            Flow {
                                anchors.fill: parent

                                Item {
                                    height: parent.height / 2
                                    width: parent.width

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData
                                        color: "white"
                                        font.pixelSize: 14
                                    }
                                }

                                Item {
                                    height: parent.height / 2
                                    width: parent.width

                                    Rectangle {
                                        width: parent.height
                                        height: parent.height
                                        anchors.centerIn: parent
                                        property string associatedName : modelData;
                                        border.color: "white"
                                        border.width: 1
                                        radius: 5

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                colorDialog.open(modelData);
                                            }
                                        }

                                        color: findColorByName(associatedName) || "gray";
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Flow {
                width: parent.width
                height: parent.height * 0.1
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10

                Rectangle { // Just for center the Buttons
                    width: (parent.width - colorMappingSaveButton.width * 3) / 2
                    height: parent.height
                    color: "transparent"
                }

                Button {
                    id: colorMappingSaveButton
                    text: "Save"
                    onClicked: {
                        colorMappings.clear();
                        for (var i = 0; i < tempColorMappingsModel.count; i++) {
                            var item = tempColorMappingsModel.get(i);
                            colorMappings.append(item);
                        }

                        printColorPairs();

                        // Grouping scatterDataModel's data
                        groupDataByAttributeWithColors(coloringButton.currentText);

                        tempColorMappingsModel.clear();
                        colorPickerPopup.close();
                    }
                }

                Button {
                    text: "Randomize"
                    onClicked: {
                        randomizeColors();
                    }
                }

                Button {
                    text: "Cancel"
                    onClicked: {
                        tempColorMappingsModel.clear();
                        colorPickerPopup.close();
                    }
                }
            }

            ColorDialog {
                id: colorDialog
                property string currentAttribute: ""

                onAccepted: {
                    if (currentAttribute !== "") {
                        let found = false;

                        for (let i = 0; i < tempColorMappingsModel.count; i++) {
                            let item = tempColorMappingsModel.get(i);
                            if (item.name === currentAttribute) {
                                tempColorMappingsModel.set(i, { name: currentAttribute, color: selectedColor.toString().toUpperCase() });
                                found = true;
                                break;
                            }
                        }

                        if (!found) {
                            tempColorMappingsModel.append({ name: currentAttribute, color: selectedColor.toString().toUpperCase() });
                        }
                    }
                }

                function open(attribute) {
                    currentAttribute = attribute;
                    visible = true;
                }
            }
        }

        onOpened: {
            tempColorMappingsModel.clear();
            for (let i = 0; i < uniqueValues.length; i++) {
                let name = uniqueValues[i];
                tempColorMappingsModel.append({ name: name, color: "gray" });
            }
            console.log("Colorpicker opened. Number of unique values: " + uniqueValues.length);
        }
    }
}
