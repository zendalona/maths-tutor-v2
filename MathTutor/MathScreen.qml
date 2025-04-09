import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0
import QtTextToSpeech
Item {
    //this is a math subject screen with different lessons such as time,currency,story based, distance, help , operations
    //each subject has a buuton
    //all buttons are arranged in a grid layout
    property int theme: 1
    property int pr_fontSizeMultiple: 0
    property bool pr_isMusicPlaying: false
    //alt+h should press the home button
    // Keys.onPressed: {
    //     if(event.key === Qt.Key_H && event.modifiers === Qt.AltModifier){
    //         mathSubjectScreen.visible = true
    //         mathBasedloader.source = ""
    //     }
    // }

    onPr_isMusicPlayingChanged: {
        if(!pr_isMusicPlaying){
            player.stop()
        }else{
            player.play()
        }
    }

    Item{
        id: mathSubjectScreen
        anchors.fill: parent
        visible: true
        Label {
            id: topLabel
            color: "green"
            font.pixelSize: pr_fontSizeMultiple +  40
            text:qsTr("Welcome To The Math Tutor ")

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


        //a on off button to change theme
        //shape must be like a Switch
        //on click change theme

        Button {
            id: themeButton
            text: "Change Theme"
            font.pixelSize: pr_fontSizeMultiple +  24
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
            font.pixelSize: pr_fontSizeMultiple +  24
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
            Material.theme: theme === 1 ? Material.Dark : Material.Light

            Rectangle {
                width: parent.width
                height: parent.height
                color: "transparent"

                Column {
                    anchors {
                        fill: parent
                        margins: 20
                    }
                    spacing: 30

                    Text {
                        text: "Application Settings"
                        font.pixelSize: pr_fontSizeMultiple + 30
                        color: Material.primaryTextColor
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                    }

                    // Font Size Settings
                    Column {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "Font Size"
                            font.pixelSize: pr_fontSizeMultiple + 20
                            color: Material.primaryTextColor
                        }

                        Row {
                            spacing: 20

                            SpinBox {
                                id: settingsFontSizeSpinBox
                                value: pr_fontSizeMultiple
                                from: 0
                                to: 50
                                stepSize: 1
                                onValueChanged: {
                                    pr_fontSizeMultiple = settingsFontSizeSpinBox.value
                                }
                            }

                            Text {
                                text: "Preview: Sample Text"
                                font.pixelSize: pr_fontSizeMultiple + 20
                                color: Material.primaryTextColor
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }

                    // Theme Settings
                    Column {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "Theme"
                            font.pixelSize: pr_fontSizeMultiple + 20
                            color: Material.primaryTextColor
                        }

                        Row {
                            spacing: 20

                            RadioButton {
                                id: lightThemeRadio
                                text: "Light Theme"
                                checked: theme === 0
                                onClicked: {
                                    theme = 0
                                }
                            }

                            RadioButton {
                                id: darkThemeRadio
                                text: "Dark Theme"
                                checked: theme === 1
                                onClicked: {
                                    theme = 1
                                }
                            }
                        }
                    }

                    // Audio Settings
                    Column {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "Audio Settings"
                            font.pixelSize: pr_fontSizeMultiple + 20
                            color: Material.primaryTextColor
                        }

                        Row {
                            spacing: 20

                            Text {
                                text: "Volume:"
                                font.pixelSize: pr_fontSizeMultiple + 16
                                color: Material.primaryTextColor
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Slider {
                                id: volumeSlider
                                from: 0
                                to: 100
                                value: 50
                                stepSize: 1
                                width: 200
                                onValueChanged: {
                                    // Set volume for all audio players
                                    // This is a placeholder - actual implementation would depend on how audio is managed
                                }
                            }

                            Text {
                                text: volumeSlider.value.toFixed(0) + "%"
                                font.pixelSize: pr_fontSizeMultiple + 16
                                color: Material.primaryTextColor
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        CheckBox {
                            id: backgroundMusicCheckbox
                            text: "Play Background Music"
                            checked: pr_isMusicPlaying
                            onCheckedChanged: {
                                pr_isMusicPlaying = backgroundMusicCheckbox.checked
                            }
                        }
                    }

                    // Save Button
                    Button {
                        text: "Save Settings"
                        width: 200
                        height: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            settingsWindow.visible = false
                            // Here you would save settings to persistent storage if needed
                        }
                    }
                }
            }
        }
        // an upload Button

        Button {
            id: uploadButton
            text: "Upload"
            font.pixelSize: pr_fontSizeMultiple +  24
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
            title: "Upload Custom Questions"
            flags: Qt.Window
            Material.theme: theme === 1 ? Material.Dark : Material.Light

            Rectangle {
                width: parent.width
                height: parent.height
                color: "transparent"

                Column {
                    anchors {
                        fill: parent
                        margins: 20
                    }
                    spacing: 20

                    Text {
                        text: "Upload Custom Question Sets"
                        font.pixelSize: pr_fontSizeMultiple + 24
                        color: Material.primaryTextColor
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        text: "Select an Excel file containing custom questions. The file should have columns for 'question', 'answer', 'type', and 'difficulty'."
                        font.pixelSize: pr_fontSizeMultiple + 16
                        color: Material.primaryTextColor
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }

                    Button {
                        text: "Browse Files"
                        width: 200
                        height: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            fileDialog.open()
                        }
                        Keys.onReturnPressed: {
                            fileDialog.open()
                        }
                        Keys.onEnterPressed: {
                            fileDialog.open()
                        }
                    }

                    Text {
                        id: uploadStatusText
                        text: ""
                        font.pixelSize: pr_fontSizeMultiple + 16
                        color: "green"
                        width: parent.width
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            FileDialog {
                id: fileDialog
                title: "Select Question File"
                nameFilters: ["Excel files (*.xlsx *.xls)"]
                onAccepted: {
                    bridge.process_file(fileDialog.selectedFile)
                    uploadStatusText.text = "File uploaded successfully!"
                    uploadStatusText.color = "green"
                }
                onRejected: {
                    uploadStatusText.text = "File selection canceled."
                    uploadStatusText.color = "red"
                }
            }
        }

        Grid{
            id: mathSubjectGrid
            spacing: 10
            // columns: 3
            rows: 2
            anchors{
                top: welcomeAnimation.bottom
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                topMargin: 10
            }

            Button{
                id: timeButton
                text: "Time"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: pr_fontSizeMultiple +  30
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
                font.pixelSize: pr_fontSizeMultiple +  30
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
                font.pixelSize: pr_fontSizeMultiple +  30
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
                font.pixelSize: pr_fontSizeMultiple +  30

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
                // visible: false
                id: bellRingingButton
                text: "Bell Ringing"
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 80
                width: 200
                font.pixelSize: pr_fontSizeMultiple +  30
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
                font.pixelSize: pr_fontSizeMultiple +  30
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

        Text{
            id: noteText
            width: mathSubjectGrid.width
            text: "Note: Please select the subject to proceed"
            font.pixelSize: pr_fontSizeMultiple + 20
            color: Material.primaryTextColor
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter

            anchors{
                top: mathSubjectGrid.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: 30
            }
            // Ensure text doesn't overlap with other elements
            z: 10
        }

    }
    Loader {
        id: mathBasedloader
        source:""
        anchors.fill: parent
        property int pr_demo: 2
    }

    ///home button sound

    MediaPlayer {
        id: homeButtonSound
        source: "sounds/home_button_sound.mp3"
        audioOutput: AudioOutput {}
        loops: 1
    }

    //a top left corner home button
    Button{
        id: homeButton
        text: "Home"
        font.pixelSize: pr_fontSizeMultiple +  30
        anchors{
            top: parent.top
            left: parent.left
            topMargin: 10
            leftMargin: 10
        }
        onClicked: {
            homeButtonSound.play()
            mathSubjectScreen.visible = true
            mathBasedloader.source = ""
        }
        Keys.onReturnPressed:{
            homeButtonSound.play()
            mathSubjectScreen.visible = true
            mathBasedloader.source = ""

        }
        Keys.onEnterPressed: {
            homeButtonSound.play()
            mathSubjectScreen.visible = true
            mathBasedloader.source = ""

        }
    }



    SpinBox {
        id: fontSizeSpinBox
        value: 0
        from: 0
        to: 50
        stepSize: 1
        onValueChanged: {
            pr_fontSizeMultiple = fontSizeSpinBox.value
            Accessible.description = "size is:" + fontSizeSpinBox.value
            tts.say("Font size is set to " + fontSizeSpinBox.value)
        }
        anchors{
            top: parent.top
            right: parent.right
            topMargin: 10
            rightMargin: 10
        }
        //give Accessible name to SpinBox
        Accessible.name: "Font Size"
        width: 150
        //give Accessible description to SpinBox
        Accessible.description: "size is:" + fontSizeSpinBox.value

    }

    Text{
        text:"Aa:"
        anchors{
            top: fontSizeSpinBox.top
            right: fontSizeSpinBox.left
            rightMargin: 10
            verticalCenter: fontSizeSpinBox.verticalCenter
        }
        font.pixelSize: pr_fontSizeMultiple +  35
        color:Material.primaryTextColor

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
            pr_isMusicPlaying = !pr_isMusicPlaying
        }
        Keys.onReturnPressed:{
            pr_isMusicPlaying = !pr_isMusicPlaying

        }
        Keys.onEnterPressed: {
            pr_isMusicPlaying = !pr_isMusicPlaying
        }
        text:"music"
    }
    Image {
        id: muteImg
        height: 40
        width: 40
        source:  pr_isMusicPlaying===true ? "images/mute.png" : "images/unmute.png"
        anchors{
            centerIn:  musicButton
        }
    }

    TextToSpeech{
        id: tts

    }
}
