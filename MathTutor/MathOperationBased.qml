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
                    additionScreen.visible = true
                    operationScreen.visible = false


                }
                Keys.onReturnPressed:{
                    additionScreen.visible = true
                    operationScreen.visible = false
                }

                Keys.onEnterPressed: {
                    additionScreen.visible = true
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
                    subtractionScreen.visible = true
                    operationScreen.visible = false

                }
                Keys.onReturnPressed:{
                    subtractionScreen.visible = true
                    operationScreen.visible = false
                }

                Keys.onEnterPressed: {
                    subtractionScreen.visible = true
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
                    multiplicationScreen.visible = true
                    operationScreen.visible = false

                }
                Keys.onReturnPressed:{
                    multiplicationScreen.visible = true
                    operationScreen.visible = false
                }

                Keys.onEnterPressed: {
                    multiplicationScreen.visible = true
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
                    divisionScreen.visible = true
                    operationScreen.visible = false

                }
                Keys.onReturnPressed:{
                    divisionScreen.visible = true
                    operationScreen.visible = false
                }

                Keys.onEnterPressed: {
                    divisionScreen.visible = true
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
                    reminderScreen.visible = true
                    operationScreen.visible = false
                }
                Keys.onReturnPressed:{
                    reminderScreen.visible = true
                    operationScreen.visible = false

                }

                Keys.onEnterPressed: {
                    reminderScreen.visible = true
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
                    percentageScreen.visible = true
                    operationScreen.visible = false

                }
                Keys.onReturnPressed:{
                    percentageScreen.visible = true
                    operationScreen.visible = false
                }

                Keys.onEnterPressed: {
                    percentageScreen.visible = true
                    operationScreen.visible = false
                }
            }
        }
    }
    OperationAddition{
        id: additionScreen
        visible: false
        anchors.fill: parent
    }
    OperationDivision{
        id: divisionScreen
        visible: false
        anchors.fill: parent
    }
    OperationMultiplication{
        id: multiplicationScreen
        visible: false
        anchors.fill: parent
    }
    OperationPercentage{
        id: percentageScreen
        visible: false
        anchors.fill: parent
    }
    OperationReminder{
        id: reminderScreen
        visible: false
        anchors.fill: parent
    }
    OperationSubtraction{
        id: subtractionScreen
        visible: false
        anchors.fill: parent
    }
}
