
import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0

Item {
    Row{
        id: row1
        anchors{
            centerIn: parent
        }

        Text{
            id:value1
            text: "80"
            font.pixelSize: 40
        }

        Image {
            id: currency1
            source: "images/rupee.png"
            width: 60
            height: 60

        }
        Text{
            id:isText
            text: "="
            font.pixelSize: 40

        }

        TextField{
            id: textField2
            placeholderText: ""
            font.pixelSize: 40
        }
        Image {
            id: currency2
            source: "images/dollar-currency-symbol.png"
            width: 60
            height: 60
        }
        Button{
            id: submit
            text: "Submit"
            onClicked: {
                excellentImage.visible = true
            }
            Keys.onReturnPressed:{
                excellentImage.visible = true
            }

            Keys.onEnterPressed: {
                excellentImage.visible = true
            }
            height: 60
        }
    }

    AnimatedImage {
        id: excellentImage
        source: "images/excellent-1.gif"
        height: 200
        width: 200
        anchors {
            top: row1.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 10
        }
        visible: false
    }
    // a help button in the corner
    Button {
        id: helpButton
        text: "Help"
        anchors {
            right: parent.right
            top: parent.top
            rightMargin: 10
            topMargin: 10
        }
        onClicked: {
            console.log("Help button clicked")
        }
        Keys.onReturnPressed:{

        }

        Keys.onEnterPressed: {

        }
    }

}
