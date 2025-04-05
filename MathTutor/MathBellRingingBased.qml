import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 6.3  // Using explicit version for better compatibility
import QtTextToSpeech

Rectangle {
    id: root
    width: 800
    height: 600
    color: "lightblue"

    // New properties to support feedback logic
    property int pr_timeTaken: 7        // Time taken in seconds (update dynamically as needed)
    property int pr_randomIndex: 1        // Random index from 1 to 3 (update dynamically as needed)
    property int pr_countWrong: 0         // Count of wrong attempts
    property int ringCount: 0             // Count of bell rings for current question

    // Text-to-Speech object
    TextToSpeech {
        id: tts
        volume: 1.0
    }

    // Feedback label to display messages on-screen
    Text {
        id: feedbackLabel
        text: ""
        anchors.top: debugConsole.bottom
        anchors.left: parent.left
        anchors.margins: 20
        font.pixelSize: 18
        color: "darkblue"
    }

    // (Assuming debugConsole is defined somewhere above in your actual code)

    // Timer for hiding wrong feedback image
    Timer {
        id: wrongFeedbackTimer
        interval: 2000
        repeat: false
        onTriggered: wrongImage.visible = false
    }

    // Timer for hiding correct feedback image
    Timer {
        id: correctFeedbackTimer
        interval: 2000
        repeat: false
        onTriggered: excellentImage.visible = false
    }

    // Sound player with error handling
    MediaPlayer {
        id: bellSound
        source: "sounds/coin.ogg"
        audioOutput: AudioOutput {
            volume: 0.8
        }
        onErrorOccurred: console.error("Sound error:", errorString, error)
        onMediaStatusChanged: console.log("Media status changed:", mediaStatus)
    }

    // Bell image with animation
    Image {
        id: bell
        width: 200
        height: 240
        source: "images/bell.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        SequentialAnimation on rotation {
            id: bellAnimation
            loops: 1
            running: false
            PropertyAnimation { to: 15; duration: 100 }
            PropertyAnimation { to: -15; duration: 200 }
            PropertyAnimation { to: 0; duration: 100 }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                ringCount++
                console.log("Bell clicked: ring count =", ringCount)
                bellAnimation.start()

                if (ringCount > questions[currentQuestionIndex].answer) {
                    pr_countWrong++
                    var wrongSound = getWrongSound()
                    console.log("Wrong answer sound:", wrongSound)
                    feedbackLabel.text = qsTr("Try Again")
                    bellSound.source = wrongSound
                    bellSound.stop()
                    bellSound.play()

                    wrongImage.visible = true
                    excellentImage.visible = false
                    wrongFeedbackTimer.start()
                    ringCount = 0
                    return
                }

                bellSound.source = "sounds/coin.ogg"
                bellSound.stop()
                bellSound.play()

                if (ringCount === questions[currentQuestionIndex].answer) {
                    var correctSound = getCorrectSound()
                    console.log("Correct answer sound:", correctSound)
                    bellSound.source = correctSound
                    bellSound.stop()
                    bellSound.play()
                    tts.say("Correct answer!")
                    
                    excellentImage.visible = true
                    wrongImage.visible = false
                    correctFeedbackTimer.start()
                    
                    ringCount = 0
                    pr_countWrong = 0

                    if (currentQuestionIndex < questions.length - 1)
                        currentQuestionIndex++
                    else {
                        console.log("Quiz completed.")
                        tts.say("Quiz completed.")
                    }
                }
            }
        }

        // Fallback visualization if image is missing
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            visible: !bell.sourceSize.width
            radius: width / 2
            Rectangle {
                width: parent.width
                height: parent.height * 0.8
                color: "gold"
                radius: width / 2
                anchors.bottom: parent.bottom
            }
            Rectangle {
                width: parent.width * 0.2
                height: parent.height * 0.3
                color: "brown"
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    // Animated feedback images
    AnimatedImage {
        id: excellentImage
        source: "images/" +
                (pr_timeTaken < 5 ? "excellent" :
                 pr_timeTaken < 10 ? "very-good" :
                 pr_timeTaken < 15 ? "good" :
                 pr_timeTaken < 20 ? "not-bad" : "okay") +
                "-" + pr_randomIndex + ".gif"
        height: 200
        width: 200
        anchors.top: questionRect.bottom
        anchors.topMargin: 45
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
    }

    AnimatedImage {
        id: wrongImage
        source: "images/" +
                (pr_countWrong === 1 ? "wrong-anwser" : "wrong-anwser-repeted") +
                "-" + (pr_countWrong > 1 && pr_randomIndex === 3 ? 1 : pr_randomIndex) +
                ".gif"
        height: 200
        width: 200
        anchors.top: questionRect.bottom
        anchors.topMargin: 45
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
    }

    // Focusable question container.
    Rectangle {
        id: questionRect
        width: 780
        height: 180
        radius: 10
        color: "#ffffffcc"
        border.color: "gray"
        border.width: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: debugConsole.bottom
        anchors.topMargin: 20

        // Ensure the container is focusable when tabbing.
        focus: true
        activeFocusOnTab: true

        onActiveFocusChanged: {
            if (activeFocus)
                announceQuestion();
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Space)
                announceQuestion();
        }

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10

            Text {
                id: questionText
                text: questions[currentQuestionIndex].question
                wrapMode: Text.Wrap
                font.pixelSize: 20
            }

            Repeater {
                model: questions[currentQuestionIndex].options
                delegate: Text {
                    text: modelData.text
                    font.pixelSize: 18
                    color: "black"
                }
            }

            Text {
                text: "Ring the bell the number of times matching the correct option."
                font.italic: true
                font.pixelSize: 14
                color: "gray"
            }
        }
    }

    // Quiz properties and logic.
    property int currentQuestionIndex: 0
    property var questions: [
        { 
            question: "If you have 2 apples and get 1 more, how many apples do you have?", 
            options: [
                { pos: 1, text: "1: one Apple" },
                { pos: 2, text: "2: two Apple" },
                { pos: 3, text: "3: Three apples" }
            ],
            answer: 3
        },
        { 
            question: "There are 3 bananas on the table. If you take away 1, how many remain?", 
            options: [
                { pos: 1, text: "1: Two bananas" },
                { pos: 2, text: "2: One banana" },
                { pos: 3, text: "3: Three bananas" }
            ],
            answer: 1
        },
        { 
            question: "What is 1 + 1?", 
            options: [
                { pos: 1, text: "1: One" },
                { pos: 2, text: "2: Two" },
                { pos: 3, text: "3: Three" }
            ],
            answer: 2
        },
        { 
            question: "If you see 1 butterfly and then 2 more fly by, how many butterflies in total?", 
            options: [
                { pos: 1, text: "1: Two" },
                { pos: 2, text: "2: Three" },
                { pos: 3, text: "3: Four" }
            ],
            answer: 2
        },
        { 
            question: "A small tree has 2 birds. If 1 bird flies away, how many are left?", 
            options: [
                { pos: 1, text: "1: One bird" },
                { pos: 2, text: "2: Two birds" },
                { pos: 3, text: "3: Three birds" }
            ],
            answer: 1
        },
        { 
            question: "What is 2 - 1?", 
            options: [
                { pos: 1, text: "1: One" },
                { pos: 2, text: "2: Two" },
                { pos: 3, text: "3: Zero" }
            ],
            answer: 1
        },
        { 
            question: "If a toy costs 3 dollars and you pay 2 dollars, how many dollars are you short?", 
            options: [
                { pos: 1, text: "1: One dollar" },
                { pos: 2, text: "2: Two dollars" },
                { pos: 3, text: "3: Three dollars" }
            ],
            answer: 1
        },
        { 
            question: "In a race, if you come in 2nd, how many racers finished before you?", 
            options: [
                { pos: 1, text: "1: One" },
                { pos: 2, text: "2: Two" },
                { pos: 3, text: "3: Three" }
            ],
            answer: 1
        },
        { 
            question: "If you mix 1 red crayon with 2 blue crayons, how many crayons do you have?", 
            options: [
                { pos: 1, text: "1: One crayon" },
                { pos: 2, text: "2: Two crayons" },
                { pos: 3, text: "3: Three crayons" }
            ],
            answer: 3
        },
        { 
            question: "What is 1 + 2?", 
            options: [
                { pos: 1, text: "1: Two" },
                { pos: 2, text: "2: Three" },
                { pos: 3, text: "3: Four" }
            ],
            answer: 2
        }
    ]

    function getCorrectSound() {
        if (pr_timeTaken < 5) {
            feedbackLabel.text = qsTr("Excellent")
            return "sounds/excellent-" + pr_randomIndex + ".ogg"
        } else if (pr_timeTaken < 10) {
            feedbackLabel.text = qsTr("Very Good")
            return "sounds/very-good-" + pr_randomIndex + ".ogg"
        } else if (pr_timeTaken < 15) {
            feedbackLabel.text = qsTr("Good")
            return "sounds/good-" + pr_randomIndex + ".ogg"
        } else if (pr_timeTaken < 20) {
            feedbackLabel.text = qsTr("Not Bad")
            return "sounds/not-bad-" + pr_randomIndex + ".ogg"
        } else {
            feedbackLabel.text = qsTr("Okay")
            return "sounds/okay-" + pr_randomIndex + ".ogg"
        }
    }

    function getWrongSound() {
        if (pr_countWrong === 1) {
            feedbackLabel.text = qsTr("Wrong")
            return "sounds/wrong-anwser-" + pr_randomIndex + ".ogg"
        } else {
            feedbackLabel.text = qsTr("Try Again")
            return "sounds/wrong-anwser-repeted-" + (pr_randomIndex === 3 ? 1 : pr_randomIndex) + ".ogg"
        }
    }

    function announceQuestion() {
        var q = questions[currentQuestionIndex]
        var speechText = "Question: " + q.question + ". "
        for (var i = 0; i < q.options.length; i++) {
            var desc = q.options[i].text.split(": ")[1]
            speechText += "Option " + q.options[i].pos + ": " + desc + ". "
        }
        tts.say(speechText)
        console.log("Announcing: " + speechText)
    }

    onCurrentQuestionIndexChanged: announceQuestion()

    Component.onCompleted: {
        console.log("Component initialized")
        announceQuestion()
        console.log("Sound source:", bellSound.source)
    }
}
