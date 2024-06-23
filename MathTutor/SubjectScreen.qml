
import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0

Item {
    id: background

    Item{
        id:buttonContainer
        visible: true
        anchors.fill: parent
        // two buttons for math and english in asame row separeted by some distance
        //make rtge buttons to be same size and centered and good looking
        Row{
            anchors{
                centerIn: parent
            }

            spacing: 120
            //make the buttons bigger and appealing
            Button {
                id: mathButton
                text: "MATHS"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                contentItem: Text {
                    text: mathButton.text
                    font: mathButton.font
                    opacity: enabled ? 1.0 : 0.3
                    color: mathButton.down ? "#17a81a" : "#21be2b"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                height: 80
                width: 200
                font.pixelSize: 30

                onClicked: {
                    console.log("Math button clicked")
                    mathScreen.visible = true
                    buttonContainer.visible = false
                }
            }
            Button {
                id: englishButton
                text: "ENGLISH"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                contentItem: Text {
                    text: englishButton.text
                    font: englishButton.font
                    opacity: enabled ? 1.0 : 0.3
                    color: englishButton.down ? "#17a81a" : "#21be2b"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    console.log("English button clicked")
                    englishScreen.visible = true
                    buttonContainer.visible = false
                }
            }
        }
    }
    MathScreen{
        id: mathScreen
        anchors.fill: parent
        visible: false
    }
    EnglishScreen{
        id: englishScreen
        anchors.fill: parent
        visible: false
    }


}
