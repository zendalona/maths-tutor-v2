import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0

Item {
    //this has 6 buttons in a grid each for an differnt math operation
   // anchors.fill: parent
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
            onClicked: {

            }
            Keys.onReturnPressed:{

            }

            Keys.onEnterPressed: {

            }
        }
        Button {
            text: "Subtraction"
            onClicked: {

            }
            Keys.onReturnPressed:{

            }

            Keys.onEnterPressed: {

            }
        }
        Button {
            text: "Multiplication"
            onClicked: {

            }
            Keys.onReturnPressed:{

            }

            Keys.onEnterPressed: {

            }
        }
        Button {
            text: "Division"
            onClicked: {

            }
            Keys.onReturnPressed:{

            }

            Keys.onEnterPressed: {

            }
        }
        Button {
            text: "Reminder"
            onClicked: {

            }
            Keys.onReturnPressed:{

            }

            Keys.onEnterPressed: {

            }
        }
        Button {
            text: "Percentage"
            onClicked:{

            }
            Keys.onReturnPressed:{

            }

            Keys.onEnterPressed: {

            }
        }
    }
}
