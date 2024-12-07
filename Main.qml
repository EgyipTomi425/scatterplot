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
            width: 1000//(scatterSeries.selectedItem < 0 ? parent.width : (parent.width > parent.height ? parent.width * 0.6 : parent.width))
            height: 1000//(scatterSeries.selectedItem < 0 ? parent.height : (parent.width > parent.height ? parent.height : parent.height * 0.6))

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
                        width: (parent.parent.width > parent.parent.height ? parent.height : 0.5 * parent.height)
                        height: parent.height
                        onClicked: {
                            var selectedAttributes = getSelectedAttributes();
                            if (selectedAttributes.length === 3) {
                                console.log(scatter.children.length);
                                scatter.children.forEach(function (child) {
                                    child.ItemModelScatterDataProxy.xPosRole = selectedAttributes[0];
                                    child.ItemModelScatterDataProxy.yPosRole = selectedAttributes[1];
                                    child.ItemModelScatterDataProxy.zPosRole = selectedAttributes[2];
                                });
                                console.log("Updated all Scatter3DSeries with: " + selectedAttributes);
                            } else if (selectedAttributes.length === 2) {
                                scatter.children.forEach(function (child) {
                                    child.ItemModelScatterDataProxy.xPosRole = selectedAttributes[0];
                                    child.ItemModelScatterDataProxy.yPosRole = selectedAttributes[1];
                                    child.ItemModelScatterDataProxy.zPosRole = "z";
                                });
                                console.log("Updated all Scatter3DSeries with two attributes. Z set to 0.");
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
                            //title: scatterDataProxy.xPosRole || "X-Axis"
                            titleVisible: true
                            labelFormat: "%.2f"
                            labelAutoAngle: 90
                        }

                        axisY {
                            id: yAxis
                            //title: scatterDataProxy.yPosRole || "Y-Axis"
                            titleVisible: true
                            labelFormat: "%.2f"
                            labelAutoAngle: 90
                        }

                        axisZ {
                            id: zAxis
                            //title: scatterDataProxy.zPosRole || "Z-Axis"
                            titleVisible: true
                            labelFormat: "%.2f"
                            labelAutoAngle: 90
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
            width: 1000//(scatterSeries.selectedItem < 0 ? 0 : (parent.width > parent.height ? parent.width * 0.4 : parent.width))
            height: 1000//(scatterSeries.selectedItem < 0 ? 0 : (parent.width > parent.height ? parent.height : parent.height * 0.4))
            //visible: scatterSeries.selectedItem >= 0

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
                        //visible: scatterSeries.selectedItem >= 0
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
                            //visible: scatterSeries.selectedItem >= 0
                        }

                        Text {
                            id: selectedCoords
                            text: "Coordinates: (N/A, N/A, N/A)"
                            color: "white"
                            font.pixelSize: 18
                            //visible: scatterSeries.selectedItem >= 0
                        }
                    }
                }
            }
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

    function createScatterPlots() {
        scatter.children.forEach(function (child) {
            if (child.constructor === Scatter3DSeries) {
                child.destroy();
            }
        });

        if (groupedData.length < 1) {
            console.log("There is no data in groupedData.");
            return;
        }

        for (let i = 0; i < groupedData.length; i++) {
            var newScatterPlot = scatterSeriesComponent.createObject(scatter, {
                baseColor: groupedData[i].color.toString(),
                itemSize: 1
            });

            if (newScatterPlot) {
                console.log("Scatter plot created with base color: " + newScatterPlot.baseColor);

                newScatterPlot.ItemModelScatterDataProxy.itemModel = scatterDataModel;
                newScatterPlot.ItemModelScatterDataProxy.xPosRole = "x";
                newScatterPlot.ItemModelScatterDataProxy.yPosRole = "y";
                newScatterPlot.ItemModelScatterDataProxy.zPosRole = "z";
            } else {
                console.error("Failed to create a new Scatter3DSeries instance.");
            }
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
        createScatterPlots();
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

    Component {
        id: scatterSeriesComponent
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
                    selectedCoords.text = //"Coordinates: \n" +
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
