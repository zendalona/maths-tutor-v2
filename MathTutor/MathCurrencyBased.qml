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
    property int pr_timeTaken: 0
    property int pr_randomIndex: Math.floor(Math.random() * 3) + 1
    property int pr_countWrong : 0
    property bool animationRunning: false ///initialize to false
    

    Component.onCompleted: {
        // This block of code is executed once the MathCurrencyBased component has been fully created and initialized.
        // It's used for one-time setup tasks.
        bridge.Pr_questionType = "currency"
        // Sets the question type in the Python backend (via the 'bridge' object) to "currency".
        // This informs the backend that we are dealing with currency-related questions.

        bridge.Pr_difficultyIndex = pr_difficulty
        // Sets the difficulty level in the Python backend to match the 'pr_difficulty' property
        // defined in this QML file. This ensures that the backend generates questions
        // appropriate for the selected difficulty.

        bridge.process_file(bridge.getfileurl())
        // Calls the 'process_file' function in the Python backend, passing it the file URL
        // obtained from the 'getfileurl' function (also in the C++ backend).
        // This likely loads and prepares data (e.g., question sets, number ranges)
        // that are needed for the currency-related math problems.

        bridge.sequence()
        // Calls the 'sequence' function in the Python backend, which is probably responsible
        // for generating the first question or setting up the initial sequence of questions.

        question.focus = true
        // Sets the input focus to the 'question' TextField, ensuring that the user can
        // immediately interact with it (e.g., type an answer) without having to click on it first.

    }

    property int pr_fontSizeMultiple: 1
    property string pr_question: bridge.Pr_question

    onPr_questionChanged:  {
        question.text = pr_question
        answer.text = ""
        answer.enabled = true
        timerforQuestion.start()
        pr_timeTaken = 0
        question.focus = true
    }

    property string pr_answer: bridge.Pr_answer

    /**
    * @brief Determines the feedback text and sound to play based on the time taken to answer.
    * @return The path to the sound file to be played.
    */
    function getCorrectSound() {
        if(pr_timeTaken < 5) {
            feedbackLabel.text = qsTr("Excellent")
            return "sounds/excellent-" + pr_randomIndex + ".ogg"
        }
        else if(pr_timeTaken < 10) {
            feedbackLabel.text = qsTr("Very Good")
            return "sounds/very-good-" + pr_randomIndex + ".ogg"
        }
        else if(pr_timeTaken < 15) {
            feedbackLabel.text = qsTr("Good")
            return "sounds/good-" + pr_randomIndex + ".ogg"
        }
        else if(pr_timeTaken < 20) {
            feedbackLabel.text = qsTr("Not Bad")
            return "sounds/not-bad-" + pr_randomIndex + ".ogg"
        }
        else {
            feedbackLabel.text = qsTr("Okay")
            return "sounds/okay-" + pr_randomIndex + ".ogg"
        }
    }

    /**
    * @brief Determines the feedback text and sound to play when the answer is incorrect.
    * @return The path to the sound file to be played.
    */
    function getWrongSound() {
        if(pr_countWrong === 1) {
            feedbackLabel.text = qsTr("Wrong")
            return "sounds/wrong-anwser-" + pr_randomIndex + ".ogg"//remember wrong-anwswser spelling
        }
        else {
            feedbackLabel.text = qsTr("Try Again")
            return "sounds/wrong-anwser-repeted-" + (pr_randomIndex === 3 ? 1 : pr_randomIndex) + ".ogg"
            //remember wrong-anwser-repeted spelling      
        }
    }

    Keys.onUpPressed:  {
        if(pr_difficulty < 4) pr_difficulty++
    }

    Keys.onDownPressed: {
        if(pr_difficulty > 0) pr_difficulty--
    }
    /**
     * @brief Generates a new question by incrementing the question index and getting a new sequence.
     *        It also focuses on the question TextField.
    */
    function generateQuestion(){
        pr_randomIndex = Math.floor(Math.random() * 3) + 1
        bridge.incrementQuestionIndex()
        bridge.sequence()
        question.focus = true
    }

    /**
     * @brief Updates the random index used for sound and animation selection when an answer is wrong.
     */
    function updateRandomIndexForWrongAnswer() {
        pr_randomIndex = Math.floor(Math.random() * 3) + 1;
    }


    Timer{
        id: timerforQuestion
        interval: 1000
        running: false
        repeat: true
        onTriggered: pr_timeTaken++
    }

    Label{
        id: question
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 250
        anchors.horizontalCenter: parent.horizontalCenter
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: pr_fontSizeMultiple + 30
        color: "orange"
        //readOnly: true
        Accessible.role: Accessible.StaticText
        Accessible.name: text
    }

    TextField {
        id: answer
        anchors.top: question.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: pr_fontSizeMultiple + 30
        color: "orange"
        width: 200
        height: 50
        focus: true
        enabled: true
    }

    Label {
        id: feedbackLabel
        anchors.top: answer.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: 200
        height: 50
        font.pixelSize: pr_fontSizeMultiple + 30
        visible: false
    }

    Keys.onReturnPressed: handleAnswer()
    Keys.onEnterPressed: handleAnswer()

    /**
    * @brief Handles the submission of an answer.
    *        Stops the timer, checks if the answer is correct, plays the appropriate sound and animation,
    *        updates the UI, and generates a new question if the answer is correct.
    */
    function handleAnswer() {
        timerforQuestion.stop()
        answer.enabled = false// disable the answer field whenanswer is submitted
        if(animationRunning) {
            animationImageExcellent.stop()
            animationImageWrong.stop()
            player.stopWithFade()
        }

        const correct = answer.text.toString() === pr_answer.toString() || 
                      qsTr(answer.text.toString() + ".0 ") === pr_answer.toString()

        if(correct) {
            player.source = getCorrectSound()
            animationImageExcellent.running = true
            console.log("Correct")
        } else {
            pr_countWrong++
            updateRandomIndexForWrongAnswer()// update pr_randomIndex on wrong answers
            player.source = getWrongSound()
            animationImageWrong.running = true
            console.log("Wrong,")
        }
        
        feedbackLabel.visible = true
        animationRunning = true
        player.playWithFade()
    }

    MediaPlayer {
        id: player
        audioOutput: AudioOutput {
            volume: 0.5
            Behavior on volume { NumberAnimation { duration: 500 } }
        }
        
        function playWithFade() {
            audioOutput.volume = 0
            play()
            audioOutput.volume = 0.5
        }
        
        function stopWithFade() {
            audioOutput.volume = 0
            stop()
        }
    }

    property int animationDuration: 2000

    ParallelAnimation {
        id: animationImageExcellent
        running: false
        
        NumberAnimation {
            target: excellentImage
            property: "opacity"
            from: 0
            to: 1
            duration: animationDuration / 4
        }
        
        SequentialAnimation {
            PauseAnimation { duration: animationDuration / 2 }
            NumberAnimation {
                target: excellentImage
                property: "opacity"
                from: 1
                to: 0
                duration: animationDuration / 4
            }
        }
        
        onStarted: {
            excellentImage.visible = true
            player.playWithFade()
        }
        onStopped: {
            excellentImage.visible = false
            animationRunning = false
            feedbackLabel.visible = false
            player.stopWithFade()
            generateQuestion()
            answer.text = ""
            answer.enabled = true
        }
    }

    ParallelAnimation {
        id: animationImageWrong
        running: false
        
        NumberAnimation {
            target: wrongImage
            property: "opacity"
            from: 0
            to: 1
            duration: animationDuration / 4
        }
        
        SequentialAnimation {
            PauseAnimation { duration: animationDuration / 2 }
            NumberAnimation {
                target: wrongImage
                property: "opacity"
                from: 1
                to: 0
                duration: animationDuration / 4
            }
        }
        
        onStarted: {
            wrongImage.visible = true
            player.playWithFade()
        }
        onStopped: {
            wrongImage.visible = false
            animationRunning = false
            feedbackLabel.visible = false
            player.stopWithFade()
            answer.text = ""
            answer.enabled = true
            //generateQuestion()
        }
    }

    AnimatedImage {
        id: excellentImage
        source: "images/" + (pr_timeTaken < 5 ? "excellent" : 
                            pr_timeTaken < 10 ? "very-good" : 
                            pr_timeTaken < 15 ? "good" : 
                            pr_timeTaken < 20 ? "not-bad" : "okay") + "-" + pr_randomIndex + ".gif"
        height: 200
        width: 200
        anchors.top: answer.bottom
        anchors.topMargin: 45
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false    }

    AnimatedImage {
        id: wrongImage
        source: "images/" + (pr_countWrong === 1 ? "wrong-anwser" : "wrong-anwser-repeted") + 
                "-" + (pr_countWrong > 1 && pr_randomIndex === 3 ? 1 : pr_randomIndex) + ".gif"
        height: 200
        width: 200
        anchors.top: answer.bottom
        anchors.topMargin: 45
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
    }
    
    Button{
        id: additionSettingsButton
        text: "Settings"
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 10
            bottomMargin:  10
        }
        onClicked: {
            additionsettingsWindow.visible = true
        }
        Keys.onReturnPressed:{
            additionsettingsWindow.visible = true
        }

        Keys.onEnterPressed: {
            additionsettingsWindow.visible = true
        }
    }
    // a upload button to upload the range of numbers to be used
    //the uploaded file should be a json file
    Button {
        id: uploadButton
        text: "Upload"
        anchors {
            right: additionSettingsButton.left
            bottom: parent.bottom
            rightMargin: 10
            bottomMargin:  10
        }
        onClicked: {
            console.log("Upload button clicked")
            fileDialog.open()
        }
        Keys.onReturnPressed:{
            console.log("Upload button clicked")
            fileDialog.open()
        }

        Keys.onEnterPressed: {
            console.log("Upload button clicked")
            fileDialog.open()
        }
    }
    //
    Button {
        id: helpButton
        text: "Help"
        anchors {
            right: uploadButton.left
            bottom: parent.bottom
            rightMargin: 10
            bottomMargin:  10
        }
        onClicked: {
            console.log("Help button clicked")



        }
        Keys.onReturnPressed:{

        }

        Keys.onEnterPressed: {

        }
    }
    FileDialog {
        id: fileDialog
        title: "Select a file"
        Component.onCompleted: {
            console.log("File : " + file)
        }
        onAccepted: {
            bridge.process_file(file)
            //parse

        }
        onRejected: {
            console.log("File selection canceled")
        }
    }

    // add a toggle in top right corner to simulate the onclicked on help
    //this is for testing purpose
    /*Button {
        id: questionsButton
        visible: false
        text: "Random Questions"
        anchors {
            right: parent.right
            top: parent.top
            rightMargin: 10
            topMargin:  80
        }
        onClicked: {
            if(questionsButton.text === "Random Questions"){

                questionsButton.text = "Sequential Questions"
                generateNextQuestion()
            }
            else{
                questionsButton.text = "Random Questions"
                question.text=generateQuestion()
            }

        }
        Keys.onReturnPressed:{

        }

        Keys.onEnterPressed:{

        }
    }*/


    ApplicationWindow {
        id: additionsettingsWindow
        visible: false
        width: 640
        height: 480
        title: "Settings"
        flags: Qt.Window
        Material.theme:theme ===1 ? Material.Dark : Material.Light
        //color: "black"
        Rectangle {
            width: parent.width
            height: parent.height
            color: "transparent"
            //a combobox to choose difficulty level
            Text{
                id: difficultySelectionText
                text: qsTr("Select Difficulty Level:")
                anchors{
                    left: parent.left
                    leftMargin: 10
                    top: parent.top
                    topMargin: 30
                }
                color: Material.primaryTextColor

            }
            ComboBox {
                id: difficultyComboBox

                textRole: "modelData"
                model: [qsTr("Simple") , "Easy", "Medium", "Hard", "Challenging"]
                currentIndex: root.pr_difficulty
                height: 50
                width: 200
                anchors{
                    left: difficultySelectionText.left
                    leftMargin: 150
                    top: parent.top
                    topMargin: 25
                }
                onCurrentIndexChanged: {
                    root.pr_difficulty = difficultyComboBox.currentIndex
                    question.text = root.generateQuestion()
                }
            }




        }
    }
}
