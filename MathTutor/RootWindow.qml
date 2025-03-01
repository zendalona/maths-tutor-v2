// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.Material
import QtMultimedia

import io.qt.textproperties 1.0

ApplicationWindow {
    id: root
    visible: true   
    width: 300
    height: 200
    Material.accent: Material.Red
    title: "Zendlona Math Tutor App"

    property var pr_var: bridge.a

    Component.onCompleted: {
        Material.theme = mathScreen.theme === 1 ? Material.Dark : Material.Light
        languageSelectionScreen.visible = true   
    }

    onPr_varChanged: {
        console.log("from qml3", pr_var)
    }

    // Language Selection Screen (Shown First)
    Item {
        id: languageSelectionScreen
        width: parent.width
        height: parent.height
        visible: true  

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: "Select Language"
                font.pixelSize: 16
                color: Material.primaryTextColor
                horizontalAlignment: Text.AlignHCenter
            }

            ComboBox {
                id: languageComboBox
                model: ["English", "Hindi", "Marathi"]
                currentIndex: 0
                width: 150
                onCurrentIndexChanged: {
                    console.log("Selected Language: ", languageComboBox.currentText)
                }
            }

            CheckBox {
                id: rememberSelection
                text: "Remember Selection"
                checked: false
            }

            Row {
                spacing: 10
                Button {
                    text: "OK"
                    onClicked: {
                        if (rememberSelection.checked) {
                            console.log("Remembered")
                        } else {
                            console.log("Not Remembered")
                        }

                        languageSelectionScreen.visible = false  // Hide language selection
                        mathScreen.visible = true  
                        root.showMaximized() 
                    }
                }
                Button {
                    text: "Cancel"
                    onClicked: Qt.quit()
                }
            }
        }
    }

    // Main Math Screen (Hidden Initially)
    MathScreen {
        id: mathScreen
        anchors.fill: parent
        visible: false  
    }
}