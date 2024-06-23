// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial


import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0

Item {
    id: background
    visible: true
    property int theme: 1
    Accessible.name: "Welcome to the Math Tutor App by Zendalona"
    Accessible.description: "Press Enter to continue"
    Item{
        id: welcomeScreen
        anchors.fill: parent
        focus: true
        Text {
            id: topLabel
            focus: true
            color: "green"
            font.pointSize: 28
            text:qsTr("WELCOME TO THE MATH TUTOR APP BY ZENDALONA")

            anchors{
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: 50
            }
        }

        AnimatedImage {
            id: welcomeAnimation
            source: "images/welcome-1.gif"
            height: 200
            width: 200
            anchors {
                top: topLabel.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: 10
            }
        }
        // a text saying press enter to continue
        // if enter is pressed go to the next screen
        Text {
            id: pressEnter
            color: "green"
            font.pointSize: 28
            text:qsTr("Press Enter to continue")

            anchors{
                top: welcomeAnimation.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: 50
            }
        }
        enabled: true
        Keys.onPressed: {
            if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                console.log("enter pressed");
                subjectScreen.visible = true
                welcomeScreen.visible = false
            }
            else {
                console.log("key pressed");
            }

        }

        MediaPlayer {
            id: player
            source: "sounds/backgroundmusic.ogg"
            audioOutput: AudioOutput {}
            loops: MediaPlayer.Infinite
            // Component.onCompleted: {
            //     player.play()
            //     //  console.log("Playing",player.playing())
            //     player.volume=0.5
            // }
        }
        Image {
            id: muteImg
            height: 50
            width: 50
            source:player.playing===true ? "images/mute.png" : "images/unmute.png"
            anchors{
                bottom: parent.bottom
                left: parent.left
                bottomMargin: 10
                leftMargin: 10
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(player.playing){
                        player.stop()
                    }else{
                        player.play()
                    }
                }
            }
        }
        //a on off button to change theme
        //shape must be like a Switch
        //on click change theme

        Button {
            id: themeButton
            text: "Change Theme"
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: 10
                rightMargin: 10
            }
            onClicked: {
                if(theme === 1){
                    theme = 0
                }else{
                    theme = 1
                }
            }
        }

        //a settings button
        //shape must be like a gear
        //on click open a new window with settings
        Button {
            id: settingsButton
            text: "Settings"
            anchors {
                bottom: parent.bottom
                right: themeButton.left
                bottomMargin: 10
                rightMargin: 10
            }
            onClicked: {
                settingsWindow.visible = true
            }
        }
        ApplicationWindow {
            id: settingsWindow
            visible: false
            width: 640
            height: 480
            title: "Settings"
            flags: Qt.Window
            Material.theme:theme ===1 ? Material.Dark : Material.Light
            Rectangle {
                width: parent.width
                height: parent.height
                Column {
                    anchors.fill: parent
                    Row {
                        spacing: 10
                        Text {
                            text: "Zendalona"
                            font.pointSize: 24
                            color: "black"
                        }
                    }
                }
            }
        }
    }

    SubjectScreen{
        id: subjectScreen
        visible: false
        anchors.fill: parent
    }

}
