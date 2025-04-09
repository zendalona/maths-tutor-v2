import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0
import QtQml.Models 2.15
import QtQuick.Dialogs
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import Qt.labs.folderlistmodel 2.1
import Qt.labs.platform 1.0
import QtQml

Item {
    id: root
    property int pr_difficulty: 1
    property int pr_bellCount: 0
    property int pr_targetBellCount: 5
    property int pr_timeTaken: 0
    property int pr_randomIndex: Math.floor(Math.random() * 3) + 1
    property int pr_countWrong: 0
    property bool pr_animationRunning: false

    Component.onCompleted: {
        generateNewTarget()
        question.focus = true
    }

    function generateNewTarget() {
        // Generate a random number between 1 and 10 based on difficulty
        var maxBells = 5 + (pr_difficulty * 2)
        pr_targetBellCount = Math.floor(Math.random() * maxBells) + 1
        pr_bellCount = 0
        question.text = "Ring the bell " + pr_targetBellCount + " times"
        timerforQuestion.start()
    }

    Keys.onUpPressed: {
        if(pr_difficulty < 4) {
            pr_difficulty++
            generateNewTarget()
        }
    }

    Keys.onDownPressed: {
        if(pr_difficulty > 0) {
            pr_difficulty--
            generateNewTarget()
        }
    }

    Timer {
        id: timerforQuestion
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            pr_timeTaken = pr_timeTaken + 1
        }
    }

    TextField {
        id: question
        width: parent.width
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 250
        }
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: pr_fontSizeMultiple + 30
        color: "orange"
        Accessible.role: Accessible.StaticText
        Accessible.name: question.text
        readOnly: true
    }

    Text {
        id: bellCountText
        text: "Bell count: " + pr_bellCount
        font.pixelSize: pr_fontSizeMultiple + 24
        color: Material.primaryTextColor
        anchors {
            top: question.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 20
        }
        Accessible.role: Accessible.StaticText
        Accessible.name: text
    }

    Button {
        id: bellButton
        text: "Ring Bell"
        font.pixelSize: pr_fontSizeMultiple + 24
        anchors {
            top: bellCountText.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 40
        }
        width: 200
        height: 80
        enabled: !pr_animationRunning

        onClicked: {
            ringBell()
        }

        Keys.onReturnPressed: {
            ringBell()
        }

        Keys.onEnterPressed: {
            ringBell()
        }

        Accessible.role: Accessible.Button
        Accessible.name: "Ring Bell"
        Accessible.description: "Press to ring the bell"
    }

    function ringBell() {
        if (pr_animationRunning) return

        pr_bellCount++
        bellSound.play()

        // Check if target reached
        if (pr_bellCount === pr_targetBellCount) {
            timerforQuestion.stop()
            checkAnswer()
        }
    }

    function checkAnswer() {
        pr_animationRunning = true
        animationImageExcellent.start()
        feedbackLabel.visible = true
        feedbackLabel.focus = true
    }

    MediaPlayer {
        id: bellSound
        source: "sounds/coin.ogg"
        audioOutput: AudioOutput {}
    }

    MediaPlayer {
        id: player
        source: ""
        audioOutput: AudioOutput {}
        loops: 1
    }

    Text {
        id: feedbackLabel
        visible: false
        anchors {
            top: bellButton.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 20
        }
        font.pixelSize: pr_fontSizeMultiple + 30
        color: "green"
        Accessible.role: Accessible.StaticText
        Accessible.name: text
    }

    AnimatedImage {
        id: excellentImage
        visible: false
        source: {
            if(pr_timeTaken < 5) {
                feedbackLabel.text = qsTr("Excellent")
                player.source = ("sounds/excellent-" + pr_randomIndex + ".ogg")
                return ("images/excellent-" + pr_randomIndex + ".gif")
            }
            else if(pr_timeTaken < 10) {
                feedbackLabel.text = qsTr("Very Good")
                player.source = ("sounds/very-good-" + pr_randomIndex + ".ogg")
                return ("images/very-good-" + pr_randomIndex + ".gif")
            }
            else if(pr_timeTaken < 15) {
                feedbackLabel.text = qsTr("Good")
                player.source = ("sounds/good-" + pr_randomIndex + ".ogg")
                return ("images/good-" + pr_randomIndex + ".gif")
            }
            else {
                feedbackLabel.text = qsTr("Not Bad")
                player.source = ("sounds/not-bad-" + pr_randomIndex + ".ogg")
                return ("images/not-bad-" + pr_randomIndex + ".gif")
            }
        }
        height: 200
        width: 200
        anchors {
            top: feedbackLabel.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 20
        }
    }

    SequentialAnimation {
        id: animationImageExcellent
        running: false
        loops: 1

        ScriptAction {
            script: {
                excellentImage.visible = true
                player.play()
            }
        }

        PauseAnimation { duration: 2000 }

        ScriptAction {
            script: {
                excellentImage.visible = false
                player.source = ""
                feedbackLabel.visible = false
                pr_animationRunning = false
                generateNewTarget()
            }
        }
    }

    // Settings button
    Button {
        id: settingsButton
        text: "Settings"
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 10
            bottomMargin: 10
        }
        onClicked: {
            settingsWindow.visible = true
        }
        Keys.onReturnPressed: {
            settingsWindow.visible = true
        }
        Keys.onEnterPressed: {
            settingsWindow.visible = true
        }
    }

    // Settings window
    ApplicationWindow {
        id: settingsWindow
        visible: false
        width: 400
        height: 300
        title: "Bell Ringing Settings"
        flags: Qt.Window
        Material.theme: theme === 1 ? Material.Dark : Material.Light

        Column {
            anchors {
                fill: parent
                margins: 20
            }
            spacing: 20

            Text {
                text: "Difficulty Level"
                font.pixelSize: pr_fontSizeMultiple + 20
                color: Material.primaryTextColor
            }

            ComboBox {
                id: difficultyComboBox
                textRole: "modelData"
                model: ["Simple", "Easy", "Medium", "Hard", "Challenging"]
                currentIndex: root.pr_difficulty
                width: parent.width
                onCurrentIndexChanged: {
                    root.pr_difficulty = difficultyComboBox.currentIndex
                    generateNewTarget()
                }
            }
        }
    }
}
