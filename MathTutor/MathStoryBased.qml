import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0

Item {
    id: root
    Text {
        id: question
        text: qsTr("If Speed is 5 km/h and time taken is 2 hrs then what is the distance travelled?")
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter

            topMargin: 250
        }
        font.pixelSize: 30
        color: "orange"
    }

    TextInput{
        focus: true
        id: answer
        text: ""
        cursorVisible: true
        anchors{
            top: question.bottom
            topMargin: 10
            horizontalCenter: parent.horizontalCenter

        }
        font.pixelSize: 30
        color: "orange"
        width: 200
        height: 50
        // a rect around this input field
        Rectangle {
            color: "transparent"
            border.color: "green"
            border.width: 2
            radius: 5
            anchors.fill: parent
        }
    }

    Keys.onReturnPressed: {
        excellentImage.visible = true
    }
    Keys.onEnterPressed: {
        excellentImage.visible = true
    }
    Component.onCompleted: {
        answer.force=TextInput.FocusReason
    }

    //a excellent image
    AnimatedImage {
        id: excellentImage
        source: "images/excellent-1.gif"
        height: 200
        width: 200
        anchors {
            top: answer.bottom
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
    }

}
