// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial


import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.Material
import QtMultimedia

import io.qt.textproperties 1.0

ApplicationWindow{

    id:root
    Material.theme:mathScreen.theme === 1 ? Material.Dark : Material.Light
    Material.accent: Material.Red
    title: "Zendlona Math Tutor App"
    visible: true
    height: 200
    width: 300
    opacity: 0

    property var pr_var: bridge.a
    Component.onCompleted: {
        console.log("from qml", bridge.getText())
        console.log("from qml1", bridge.getColor("red"))

        bridge.textChanged()
       // console.log("from qml2", pr_var)
        bridge.a = [1,2,3]
        bridge.appendValue(7)
    }

    onPr_varChanged: {
        console.log("from qml3", pr_var)
    }



    ApplicationWindow{
        id: languageSelectionScreen
        visible: true
        title: "Zendlona Math Tutor App"
        maximumHeight:  200
        maximumWidth:  300
        minimumHeight: 200
        minimumWidth: 300
        onClosing: {
            if(welcomeScreenWindow.visible ===false ){
                root.close()
            }
        }

        Item{

            Text{
                id: languageSelectionText
                text: "Select Language"
                anchors{
                    left: parent.left
                    leftMargin: 10
                    top: parent.top
                    topMargin: 30
                }
            }
            //a drop down menu to select language
            ComboBox{
                id: languageComboBox
                model: ["English", "Hindi", "Marathi"]
                currentIndex: 0
                height: 30
                anchors{
                    left: languageSelectionText.left
                    leftMargin: 100
                    top: parent.top
                    topMargin: 25
                }
            }
            //a remeber selection CheckBox
            CheckBox{
                id: rememberSelection
                text: "Remember Selection"
                checked: false
                anchors{
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
            //a ok button to move to next screen
            Button{
                id: okButton
                text: "OK"
                anchors{
                    left: languageSelectionText.left
                    leftMargin: 10
                    top: rememberSelection.bottom
                    topMargin: 10
                }
                onClicked: {
                    if(rememberSelection.checked){
                        console.log("Remembered")
                    }
                    else{
                        console.log("Not Remembered")
                    }
                    root.visibility= Window.Maximized
                    root.minimumHeight= 720
                    root.minimumWidth= 1080
                    welcomeScreenWindow.visible= true
                    welcomeScreenWindow.visibility= Window.Maximized
                    languageSelectionScreen.close()
                }
                Keys.onEnterPressed: {
                    if(rememberSelection.checked){
                        console.log("Remembered")
                    }
                    else{
                        console.log("Not Remembered")
                    }
                    root.visibility= Window.Maximized
                    root.minimumHeight= 720
                    root.minimumWidth= 1080
                    welcomeScreenWindow.visible= true
                    welcomeScreenWindow.visibility= Window.Maximized
                    languageSelectionScreen.close()
                }
                Keys.onReturnPressed: {
                    if(rememberSelection.checked){
                        console.log("Remembered")
                    }
                    else{
                        console.log("Not Remembered")
                    }
                    root.visibility= Window.Maximized
                    root.minimumHeight= 720
                    root.minimumWidth= 1080
                    welcomeScreenWindow.visible= true
                    welcomeScreenWindow.visibility= Window.Maximized
                    languageSelectionScreen.close()
                }
            }
            //a cancel button to close the application
            Button{
                id: cancelButton
                text: "Cancel"
                anchors{
                    left: okButton.right
                    leftMargin: 10
                    top: rememberSelection.bottom
                    topMargin: 10
                }
                onClicked: {
                    root.close()
                }
            }
        }
    }



    ApplicationWindow{
        id: welcomeScreenWindow
        minimumHeight: 720
        minimumWidth: 1080
        title: "Zendlona Math Tutor App"
        //visibility: Window.Maximized
        //close this window until the language is selected
        visible: false
        onClosing: {
            root.close()
        }

        MathScreen{
            id: mathScreen
            anchors.fill: parent
            visible: true
        }
    }
}


