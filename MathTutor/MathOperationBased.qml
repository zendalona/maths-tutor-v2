import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0

Item{
    Item {
        id:operationScreen
        //this has 6 buttons in a grid each for an differnt math operation
        // anchors.fill: parent
        anchors{
            centerIn: parent
        }
        visible: true
        Grid{
            spacing: 10
            columns: 3
            anchors{
                centerIn: parent
            }

            id: grid
            Button {
                text: "Addition"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    operationBasedloader.source = "OperationAddition.qml"
                    operationScreen.visible = false


                }
                Keys.onReturnPressed:{
                    operationBasedloader.source = "OperationAddition.qml"
                    operationScreen.visible = false
                }

                Keys.onEnterPressed: {
                    operationBasedloader.source = "OperationAddition.qml"
                    operationScreen.visible = false
                }
            }
            Button {
                text: "Subtraction"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    operationBasedloader.source = "OperationSubtraction.qml"
                    operationScreen.visible = false

                }
                Keys.onReturnPressed:{
                    operationBasedloader.source = "OperationSubtraction.qml"
                    operationScreen.visible = false
                }

                Keys.onEnterPressed: {
                    operationBasedloader.source = "OperationSubtraction.qml"
                    operationScreen.visible = false
                }
            }
            Button {
                text: "Multiplication"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    operationBasedloader.source = "OperationMultiplication.qml"
                    operationScreen.visible = false

                }
                Keys.onReturnPressed:{
                    operationBasedloader.source = "OperationMultiplication.qml"
                    operationScreen.visible = false
                }

                Keys.onEnterPressed: {
                    operationBasedloader.source = "OperationMultiplication.qml"
                    operationScreen.visible = false
                }
            }
            Button {
                text: "Division"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    operationBasedloader.source = "OperationDivision.qml"
                    operationScreen.visible = false

                }
                Keys.onReturnPressed:{
                    operationBasedloader.source = "OperationDivision.qml"
                    operationScreen.visible = false
                }

                Keys.onEnterPressed: {
                    operationBasedloader.source = "OperationDivision.qml"
                    operationScreen.visible = false
                }
            }
            Button {
                text: "Reminder"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    operationBasedloader.source = "OperationReminder.qml"
                    operationScreen.visible = false
                }
                Keys.onReturnPressed:{
                    operationBasedloader.source = "OperationReminder.qml"
                    operationScreen.visible = false

                }

                Keys.onEnterPressed: {
                    operationBasedloader.source = "OperationReminder.qml"
                    operationScreen.visible = false
                }
            }
            Button {
                text: "Percentage"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked:{
                    operationBasedloader.source = "OperationPercentage.qml"
                    operationScreen.visible = false

                }
                Keys.onReturnPressed:{
                    operationBasedloader.source = "OperationPercentage.qml"
                    operationScreen.visible = false
                }

                Keys.onEnterPressed: {
                    operationBasedloader.source = "OperationPercentage.qml"
                    operationScreen.visible = false
                }
            }
        }
    }

    Loader{
        id: operationBasedloader
        source:""
        anchors.fill: parent
    }
}
