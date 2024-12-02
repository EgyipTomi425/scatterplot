import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel 2.1
import QtQuick.Dialogs

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    color: "black"

    FileDialog {
        id: fileDialog
        title: "Select a CSV File"
        nameFilters: ["*.csv"]
        onAccepted: {
            var filePath = fileDialog.fileUrl.toString().replace("file://", "");
            loadCSVData(filePath);
        }
        onRejected: {
            console.log("File selection was cancelled.");
        }
    }

    Button {
        text: "Load CSV Data"
        width: 200
        height: 50
        anchors.centerIn: parent
        onClicked: {
            fileDialog.open();
        }
    }

    ListModel {
        id: scatterDataModel
        // Az üres modell alapértelmezett állapotban
    }

    function loadCSVData(filePath) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "file://" + filePath, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4 && xhr.status == 200) {
                var csvData = xhr.responseText.split("\n");
                for (var i = 0; i < csvData.length; i++) {
                    if (csvData[i].trim() !== "") {
                        var columns = csvData[i].split(",");
                        var itemName = columns[0];
                        var x = parseFloat(columns[1]);
                        var y = parseFloat(columns[2]);
                        var z = parseFloat(columns[3]);
                        var image = itemName + "_fat.png";
                        var folder = "/home/kecyke/Letöltések/images/";

                        scatterDataModel.append({
                            id: itemName,
                            x: x,
                            y: y,
                            z: z,
                            name: itemName,
                            image: image,
                            folder: folder
                        });
                    }
                }
            } else if (xhr.readyState == 4) {
                console.log("Failed to load CSV file.");
            }
        }
        xhr.send();
    }
}
