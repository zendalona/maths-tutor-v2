import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0

Item {
    Image {
        id: clock
        source: "images/clock.png"
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter

            topMargin: 200
        }
        height: 200
        width: 200

    }
    Text {
        id: time
        text: "Enter Time"
        font.pixelSize: 20
        anchors{
            top: clock.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 10
        }
    }
    //take teh answer as Input
    Row{
        id: userinput
        anchors{
            top: time.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 10
        }
        TextField {
            id: inputhr
            placeholderText: "hr"
            font.pixelSize: 20

        }
        TextField{
            id: inputmin
            placeholderText: "min"
            font.pixelSize: 20
        }
        Button{
            id: submit
            text: "Submit"
            onClicked: {
                excellentImage.visible = true
            }
            Keys.onReturnPressed:{
                excellentImage.visible  = true
            }

            Keys.onEnterPressed: {
                excellentImage.visible  = true
            }
        }
    }
    AnimatedImage {
        id: excellentImage
        source: "images/excellent-1.gif"
        height: 200
        width: 200
        anchors {
            top: userinput.bottom
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
