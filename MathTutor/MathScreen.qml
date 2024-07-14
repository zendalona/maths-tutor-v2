import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0

Item {
    //this is a math subject screen with different lessons such as time,currency,story based, distance, help , operations
    //each subject has a buuton
    //all buttons are arranged in a grid layout

    Item{
        id: mathSubjectScreen
        anchors.fill: parent
        visible: true
        Grid{
            spacing: 10
            columns: 3
            anchors{
                centerIn: parent
            }

            Button{
                id: timeButton
                text: "Time"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                Keys.onReturnPressed:{
                    mathSubjectScreen.visible = false
                    mathTime.visible = true
                }
                Keys.onEnterPressed: {
                    mathSubjectScreen.visible = false
                    mathTime.visible = true
                }
                onClicked: {
                    mathSubjectScreen.visible = false
                    mathTime.visible = true

                }
            }
            Button{
                id: currencyButton
                text: "Currency"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    mathSubjectScreen.visible = false
                    mathCurrency.visible = true
                }
                Keys.onReturnPressed:{
                    mathSubjectScreen.visible = false
                    mathCurrency.visible = true
                }
                Keys.onEnterPressed: {
                    mathSubjectScreen.visible = false
                    mathCurrency.visible = true
                }
            }
            Button{
                id: storyBasedButton
                text: "Story"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    mathSubjectScreen.visible = false
                    mathStoryBased.visible = true
                }
                Keys.onEnterPressed: {
                    mathSubjectScreen.visible = false
                    mathStoryBased.visible = true
                }
                Keys.onReturnPressed:{
                    mathSubjectScreen.visible = false
                    mathStoryBased.visible = true
                }
            }
            Button{
                id: distanceButton
                text: "Distance"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                //even on enter pressed
                Keys.onReturnPressed:{
                    mathSubjectScreen.visible = false
                    mathDistance.visible = true
                }

                Keys.onEnterPressed: {
                    mathSubjectScreen.visible = false
                    mathDistance.visible = true
                }

                onClicked: {
                    mathSubjectScreen.visible = false
                    mathDistance.visible = true

                }
            }
            Button{
                id: helpButton
                text: "Help"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    // mathSubjectScreen.visible = false
                }
                Keys.onReturnPressed:{

                }

                Keys.onEnterPressed: {

                }
            }
            Button{
                id: operationsButton
                text: "Operations"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    mathSubjectScreen.visible = false
                    mathOperations.visible = true
                }
                Keys.onReturnPressed:{
                    mathSubjectScreen.visible = false
                    mathOperations.visible = true
                }

                Keys.onEnterPressed: {
                    mathSubjectScreen.visible = false
                    mathOperations.visible = true
                }
            }
        }
    }

    MathStoryBased{
        id: mathStoryBased
        visible: false
        anchors.fill: parent
    }
    MathTimeScreen{
        id: mathTime
        visible: false
        anchors.fill: parent

    }
    MathCurrencyScreen{
        id: mathCurrency
        visible: false
        anchors.fill: parent

    }
    MathDistanceBased{
        id: mathDistance
        visible: false
        anchors.fill: parent
    }
    MathOperationBased{
        id: mathOperations
        visible: false
        anchors.fill: parent
    }

}
