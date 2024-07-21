import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0

Item {
    //this is a math subject screen with different lessons such as time,currency,story based, distance, help , operations
    //each subject has a buuton
    //all buttons are arranged in a grid layout
    property int theme: 1

    Item{
        id: mathSubjectScreen
        anchors.fill: parent
        visible: true
        Text {
            id: topLabel
            color: "green"
            font.pointSize: 28
            text:qsTr("Welcome To The Math Tutor App")

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
        Button{
            id:musicButton
            height: 50
            width: 50
            opacity: 1
            anchors{
                bottom: parent.bottom
                left: parent.left
                bottomMargin: 10
                leftMargin: 10
            }

            onClicked: {
                if(player.playing){
                    player.stop()
                }else{
                    player.play()
                }
            }
            Keys.onReturnPressed:{
                if(player.playing){
                    player.stop()
                }else{
                    player.play()
                }
            }
            Keys.onEnterPressed: {
                if(player.playing){
                    player.stop()
                }else{
                    player.play()
                }
            }
        }
        Image {
            id: muteImg
            height: 40
            width: 40
            source:player.playing===true ? "images/mute.png" : "images/unmute.png"
            anchors{
                centerIn:  musicButton
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
            Keys.onReturnPressed:{
                if(theme === 1){
                    theme = 0
                }else{
                    theme = 1
                }
            }

            Keys.onEnterPressed: {
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
            Keys.onReturnPressed:{
                settingsWindow.visible = true
            }

            Keys.onEnterPressed: {
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
                color: "transparent"

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
        // an upload Button

        Button {
            id: uploadButton
            text: "Upload"
            anchors {
                bottom: parent.bottom
                right: settingsButton.left
                bottomMargin: 10
                rightMargin: 10
            }
            onClicked: {
                uploadWindow.visible = true
            }
            Keys.onReturnPressed:{
                uploadWindow.visible = true
            }

            Keys.onEnterPressed: {
                uploadWindow.visible = true
            }
        }
        ApplicationWindow {
            id: uploadWindow
            visible: false
            width: 640
            height: 480
            title: "Upload"
            flags: Qt.Window
            Material.theme:theme ===1 ? Material.Dark : Material.Light
            Rectangle {
                width: parent.width
                height: parent.height
                color: "transparent"

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

        Grid{
            id: mathSubjectGrid
            spacing: 10
            columns: 3
            anchors{
                centerIn: parent
            }

            Button{
                id: timeButton
                text: "Time"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                Keys.onReturnPressed:{
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathTimeBased.qml"
                }
                Keys.onEnterPressed: {
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathTimeBased.qml"
                }
                onClicked: {
                    mathBasedloader.source = "MathTimeBased.qml"
                    mathSubjectScreen.visible = false
                }
            }
            Button{
                id: currencyButton
                text: "Currency"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathCurrencyBased.qml"
                }
                Keys.onReturnPressed:{
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathCurrencyBased.qml"
                }
                Keys.onEnterPressed: {
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathCurrencyBased.qml"
                }
            }
            Button{
                id: storyBasedButton
                text: "Story"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathStoryBased.qml"
                }
                Keys.onEnterPressed: {
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathStoryBased.qml"
                }
                Keys.onReturnPressed:{
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathStoryBased.qml"
                }
            }
            Button{
                id: distanceButton
                text: "Distance"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30

                Keys.onReturnPressed:{
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathDistanceBased.qml"
                }

                Keys.onEnterPressed: {
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathDistanceBased.qml"
                }

                onClicked: {
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathDistanceBased.qml"

                }
            }
            Button{
                id: bellRingingButton
                text: "Bell Ringing"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    mathSubjectScreen.visible = false
                   mathBasedloader.source = "MathBellRingingBased.qml"
                }
                Keys.onReturnPressed:{
                    mathSubjectScreen.visible = false
                   mathBasedloader.source = "MathBellRingingBased.qml"
                }

                Keys.onEnterPressed: {
                    mathSubjectScreen.visible = false
                   mathBasedloader.source = "MathBellRingingBased.qml"
                }
            }
            Button{
                id: operationsButton
                text: "Operations"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: 30
                onClicked: {
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathOperationBased.qml"
                }
                Keys.onReturnPressed:{
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathOperationBased.qml"
                }

                Keys.onEnterPressed: {
                    mathSubjectScreen.visible = false
                    mathBasedloader.source = "MathOperationBased.qml"
                }
            }
        }
    }
    Loader {
        id: mathBasedloader
        source:""
        anchors.fill: parent
    }

    //a top left corner home button
    Button{
        id: homeButton
        text: "Home"
        Layout.fillWidth: true
        Layout.fillHeight: true
        height: 80
        width: 200
        font.pixelSize: 30
        anchors{
            top: parent.top
            left: parent.left
            topMargin: 10
            leftMargin: 10
        }
        onClicked: {
            mathSubjectScreen.visible = true
            mathBasedloader.source = ""
        }
        Keys.onReturnPressed:{
            mathSubjectScreen.visible = true
            mathBasedloader.source = ""

        }
        Keys.onEnterPressed: {
            mathSubjectScreen.visible = true
            mathBasedloader.source = ""

        }
    }
}
