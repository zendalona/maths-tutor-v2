// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial


import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.Material
import QtMultimedia

import io.qt.textproperties 1.0


ApplicationWindow { // languageSelectionScreen is now the top-level window
    id: languageSelectionScreen
    Material.theme: mathScreen.theme === 1 ? Material.Dark : Material.Light
    Material.accent: Material.Red
    title: "Zendalona Math Tutor App"
    visible: true
    width: 300
    height: 200

    property var pr_var: bridge.a

    Component.onCompleted: {
        console.log("from qml", bridge.getText())
        console.log("from qml1", bridge.getColor("red"))
        bridge.textChanged()
        bridge.asetter = [1, 2, 3]
        bridge.appendValue(7)
    }

    onPr_varChanged: {
        console.log("from qml3", pr_var)
    }

    maximumHeight: 200
    maximumWidth: 300
    minimumHeight: 200
    minimumWidth: 300

    Item { // languageSelectionScreen content
        anchors.fill: parent

        Text {
            id: languageSelectionText
            text: "Select Language"
            anchors {
                left: parent.left
                leftMargin: 10
                top: parent.top
                topMargin: 30
            }
            color: Material.primaryTextColor
        }
        ComboBox {
            id: languageComboBox
            model: ["English", "Hindi", "Marathi"]
            currentIndex: 0
            height: 32
            anchors {
                left: languageSelectionText.left
                leftMargin: 120
                top: parent.top
                topMargin: 25
            }
            onCurrentIndexChanged: {
                console.log("Selected Language: ", languageComboBox.currentText)
            }
        }
        CheckBox {
            id: rememberSelection
            text: "Remember Selection"
            checked: false
            anchors {
                left: languageSelectionText.left
                leftMargin: 10
                top: languageComboBox.bottom
                topMargin: 10
            }
            onClicked: {
                rememberSelection.checked = !rememberSelection.checked
            }
            onPressed: {
                rememberSelection.checked = !rememberSelection.checked
            }
            Keys.onEnterPressed: {
                rememberSelection.checked = !rememberSelection.checked
            }
            Keys.onReturnPressed: {
                rememberSelection.checked = !rememberSelection.checked
            }
        }
        Button {
            id: okButton
            text: "OK"
            anchors {
                left: languageSelectionText.left
                leftMargin: 10
                top: rememberSelection.bottom
                topMargin: 10
            }
            onClicked: {
                if (rememberSelection.checked) {
                    console.log("Remembered");
                } else {
                    console.log("Not Remembered");
                }     
                welcomeScreenWindow.show(); // Show welcome screen window
                languageSelectionScreen.hide(); // Hide language selection window
            }
            Keys.onEnterPressed: {
               if (rememberSelection.checked) {
                    console.log("Remembered");
                } else {
                    console.log("Not Remembered");
                }     
                welcomeScreenWindow.show(); // Show welcome screen window
                languageSelectionScreen.hide(); // Hide language selection window
            }
            Keys.onReturnPressed: {
                if (rememberSelection.checked) {
                    console.log("Remembered");
                } else {
                    console.log("Not Remembered");
                }     
                welcomeScreenWindow.show(); // Show welcome screen window
                languageSelectionScreen.hide(); // Hide language selection window
            }
        Button {
            id: cancelButton
            text: "Cancel"
            anchors {
                left: okButton.right
                leftMargin: 10
                top: rememberSelection.bottom
                topMargin: 10
            }
            onClicked: {
                Qt.quit();
            }
        }
    }

   ApplicationWindow { // Welcome Screen Window
    id: welcomeScreenWindow
    Material.theme: mathScreen.theme === 1 ? Material.Dark : Material.Light
    Material.accent: Material.Red
    title: "Zendlona Math Tutor App"
    visible: false // Initially hidden
    width: 1080
    height: 800
    onClosing: Qt.quit()  // Ensures the program quits when the window is closed


    MathScreen {
        id: mathScreen
        anchors.fill: parent
        visible: true
        }
     }
   }
 }
