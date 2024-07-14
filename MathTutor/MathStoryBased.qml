import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0

Item {
    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 10
        Text {
            id: question
            text: qsTr("Lily is a young girl who lives in a small village. One day, she decided to visit her grandmother who lives on the other side of the village. To get there, she has to follow a series of directions.
                        Directions
                        From her house, Lily walks 2 blocks north to the bakery.
                        She then turns right and walks 3 blocks east to the library.
                        From the library, she turns left and walks 1 block north to the park.
                        Finally, she turns left again and walks 4 blocks west to her grandmother's house.")

            wrapMode: Text.WordWrap
            font.pixelSize: 18
            color: "orange"
        }
        Text{
            id:subquestion
            text: qsTr("How many blocks does Lily walk east after visiting the bakery?")
            wrapMode: Text.WordWrap
            font.pixelSize: 18
            color: "orange"
        }
        TextField {
            id: answer
            width: 400
            placeholderText: qsTr("")
        }
        Button {
            id: submit
            text: qsTr("Submit")
            onClicked: {
                excellentImage.visible = true
            }
            Keys.onReturnPressed:{
                excellentImage.visible = true
            }

            Keys.onEnterPressed: {
                excellentImage.visible = true
            }
        }
    }
    AnimatedImage {
        id: excellentImage
        source: "images/excellent-1.gif"
        height: 200
        width: 200
        anchors {
            top: layout.bottom
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
