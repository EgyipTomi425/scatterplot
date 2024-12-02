import QtQuick
import QtQuick.Controls
import QtGraphs
import QtQuick.Dialogs
import scatterplot.csvreader

ApplicationWindow {
    visible: true
    width: 800
    height: 600
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
                            var testData = csvReader.readCsv("/home/kecyke/Letöltések/project/data_filtered_cleaned.csv");
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
                                scatterSeries.xPosRole = selectedAttributes[0];
                                scatterSeries.yPosRole = selectedAttributes[1];
                                scatterSeries.zPosRole = selectedAttributes[2];
                                console.log("Updated Scatter3D with: " + selectedAttributes);
                            } else {
                                console.error("Please select exactly three attributes.");
                            }
                        }
                    }
                }

                Scatter3D {
                    id: scatter
                    width: parent.width
                    height: parent.height * 0.9

                    Scatter3DSeries {
                        id: scatterSeries
                        ItemModelScatterDataProxy {
                            itemModel: scatterDataModel
                        }

                        baseColor: "blue"

                        onSelectedItemChanged: {
                            if (selectedItem >= 0) {
                                var item = scatterDataModel.get(selectedItem);
                                selectedName.text = "Name: " + (item.name || "N/A");
                                selectedCoords.text = "Coordinates: ("
                                                      + (item[scatterSeries.xPosRole] || "N/A") + ", "
                                                      + (item[scatterSeries.yPosRole] || "N/A") + ", "
                                                      + (item[scatterSeries.zPosRole] || "N/A") + ")";
                                selectedImage.source = "file:///home/kecyke/Letöltések/images/" + (item.id + "_fat.png" || "");
                            } else {
                                selectedName.text = "Name: None";
                                selectedCoords.text = "Coordinates: (N/A, N/A, N/A)";
                                selectedImage.source = "";
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
        }
    }
}
