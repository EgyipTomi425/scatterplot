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

    property var scatterDataModel: ListModel {}

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

                Row {
                    width: parent.width
                    height: parent.height * 0.1

                    Rectangle {
                        id: checkboxfieldRect
                        width: parent.width - 2 * parent.height
                        height: parent.height
                        color: "#303030"

                        Flow {
                            id: checkboxLayout
                            anchors.fill: parent
                            spacing: 10
                        }
                    }

                    Button {
                        id: readerButton
                        text: "Load Test Data"
                        width: parent.height
                        height: parent.height
                        onClicked: {
                            var testData = csvReader.readCsv("/home/kecyke/Letöltések/project/data_with_bmi_and_category.csv");
                            scatterDataModel.clear();
                            testData.forEach(function (item, index) {
                                scatterDataModel.append(item);
                                console.log("Item " + index + ": " + JSON.stringify(scatterDataModel.get(index)));
                            });
                            createCheckboxesForNumericAttributes();
                        }
                    }

                    Button {
                        id: updateButton
                        text: "Update Scatter Plot"
                        width: parent.height
                        height: parent.height
                        onClicked: {
                            var selectedAttributes = getSelectedAttributes();
                            if (selectedAttributes.length === 3) {
                                // Három attribútum esetén
                                scatterDataProxy.xPosRole = selectedAttributes[0];
                                scatterDataProxy.yPosRole = selectedAttributes[1];
                                scatterDataProxy.zPosRole = selectedAttributes[2];
                                console.log("Updated Scatter3D with: " + selectedAttributes);
                            } else if (selectedAttributes.length === 2) {
                                // Két attribútum esetén a harmadik dimenziót 0-ra állítjuk
                                scatterDataProxy.xPosRole = selectedAttributes[0];
                                scatterDataProxy.yPosRole = selectedAttributes[1];
                                scatterDataProxy.zPosRole = "z";
                                console.log("Updated Scatter3D with two attributes. Z set to 0.");
                                // Beállítjuk, hogy a harmadik dimenzió értéke mindig 0 legyen
                                scatterDataProxy.setItemDataFunction = function (index, item) {
                                    item["z"] = 0; // Minden z érték 0-ra állítása
                                };
                            } else {
                                console.error("Please select exactly two or three attributes.");
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: parent.height

                    Scatter3D {
                        id: scatter
                        width: parent.width
                        height: parent.height * 0.9
                        aspectRatio: 1
                        horizontalAspectRatio: 1

                        orthoProjection: true

                        axisX {
                            id: xAxis
                            title: scatterDataProxy.xPosRole || "X-Axis"
                            titleVisible: true
                            labelFormat: "%.2f"
                        }

                        axisY {
                            id: yAxis
                            title: scatterDataProxy.yPosRole || "Y-Axis"
                            titleVisible: true
                            labelFormat: "%.2f"
                        }

                        axisZ {
                            id: zAxis
                            title: scatterDataProxy.zPosRole || "Z-Axis"
                            titleVisible: true
                            labelFormat: "%.2f"
                        }

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
                            itemSize: 0.1

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
                    }

                    Slider {
                        width: 400
                        height: 50
                        anchors.top: scatter.top
                        anchors.right: scatter.right
                        anchors.margins: 10

                        stepSize: 0.01

                        onValueChanged: {
                            scatterSeries.itemSize = value;
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
    }

    CsvReader {
        id: csvReader
    }

    ListModel {
        id: scatterDataModel
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

    Component {
        id: checkboxComponent
        CheckBox {
            text: "Attribute"
            checked: false
            font.pixelSize: parent.height / 4
        }
    }
}
