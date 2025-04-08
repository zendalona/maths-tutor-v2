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
    // page up and  down to change the difficulty level
    property int pr_timeTaken: 0
    // a random value between 1-3
    property int pr_randomIndex: Math.floor(Math.random() * 3) + 1
    property int pr_countWrong : 0

    Component.onCompleted: {
        bridge.Pr_questionType = "time"
        bridge.Pr_difficultyIndex = pr_difficulty
        bridge.process_file(bridge.getfileurl())
        bridge.sequence()
        question.focus = true
    }



    property string pr_question: bridge.Pr_question

    onPr_questionChanged:  {
        console.log("pr_question",pr_question)
        question.text = pr_question
        question.focus = true
    }

    property string pr_answer: bridge.Pr_answer

    onPr_answerChanged:  {
        console.log("pr_answer",pr_answer)
    }



    Keys.onUpPressed:  {
        if(pr_difficulty < 4){
            pr_difficulty++
        }
    }
    Keys.onDownPressed: {
        if(pr_difficulty > 0){
            pr_difficulty--
        }
    }
    function generateQuestion(){
        bridge.incrementQuestionIndex()
        bridge.sequence()
        question.focus = true
    }

    Timer{
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
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter

            topMargin: 250
        }
        wrapMode: Text.WordWrap // Enables text wrapping
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: pr_fontSizeMultiple +  30
        color: "orange"
        //add Accessible properties
        Accessible.role: Accessible.StaticText
        Accessible.name: question.text
        readOnly : true

    }

    TextField{
        focus: true
        id: answer
        text: ""
        cursorVisible: true
        anchors{
            top: question.bottom
            topMargin: 10
            horizontalCenter: parent.horizontalCenter

        }

        font.pixelSize: pr_fontSizeMultiple +  30
        color: "orange"
        width: 200
        height: 50
    }

    Label{
        id:feedbackLabel
        anchors{
            top:answer.bottom
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
        width: 200
        height: 50
        font.pixelSize: pr_fontSizeMultiple +  30
        visible: false

    }

    Keys.onReturnPressed: {
        timerforQuestion.stop()
        console.log("Correct answer", pr_answer.toString())
        console.log("User answer", answer.text)
        if(answer.text.toString() === pr_answer.toString() || qsTr((answer.text.toString() + ".0 ")) === pr_answer.toString()){
            animationImageExcellent.running = true
            feedbackLabel.visible = true
            feedbackLabel.focus = true
            player.play()


        }
        else{
            pr_countWrong++
            animationImageWrong.running = true
            feedbackLabel.visible = true
            feedbackLabel.focus = true
            player.play()
        }
    }
    Keys.onEnterPressed: {
        timerforQuestion.stop()
        console.log("Correct answer", pr_answer.toString())
        console.log("User answer", answer.text)
        if(answer.text.toString() === pr_answer.toString() || qsTr((answer.text.toString() + ".0 ")) === pr_answer.toString()){
            animationImageExcellent.running = true
            feedbackLabel.visible = true
            feedbackLabel.focus = true
            player.play()

        }
        else{
            pr_countWrong++
            animationImageWrong.running = true
            feedbackLabel.visible = true
            feedbackLabel.focus = true
            player.play()

        }
    }

    MediaPlayer {
        id: player
        source: ""
        audioOutput: AudioOutput {}
        loops: MediaPlayer.Infinite
        // Component.onCompleted: {
        //     player.play()
        //     //  console.log("Playing",player.playing())
        //     player.volume=0.5
        // }
    }

    //afteer the animation is done, hide the image and generate a new question
    SequentialAnimation {
        id: animationImageExcellent
        running: false
        loops: 1
        NumberAnimation {
            target: excellentImage
            property: "visible"
            from: 1
            to: 0
            duration: 2000
        }
        onStopped: {
            animationImageExcellent.running = false
            player.source=""
            feedbackLabel.visible = false
            generateQuestion()
            answer.text = ""
        }
    }
    SequentialAnimation {
        id: animationImageWrong
        running: false
        loops: 1
        NumberAnimation {
            target: wrongImage
            property: "visible"
            from: 1
            to: 0
            duration: 2000
        }
        onStopped: {
            animationImageWrong.running = false
            player.source=""
            feedbackLabel.visible = false
            answer.text = ""
        }
    }

    AnimatedImage {
        id: excellentImage
        source: {
            if(pr_timeTaken < 5){
                feedbackLabel.text= qsTr("Excellent")
                player.source=("sounds/excellent-"+ pr_randomIndex + ".ogg")
                return ("images/excellent-"+ pr_randomIndex + ".gif")

            }
            else if(pr_timeTaken<10){
                feedbackLabel.text= qsTr("very-good")
                player.source=("sounds/very-good-"+ pr_randomIndex + ".ogg")

                return ("images/very-good-"+ pr_randomIndex + ".gif")
            }
            else if(pr_timeTaken<15){
                feedbackLabel.text= qsTr("good")
                player.source=("sounds/good-"+ pr_randomIndex + ".ogg")

                return ("images/good-"+ pr_randomIndex + ".gif")
            }
            else if(pr_timeTaken<15){
                feedbackLabel.text= qsTr("not-bad")
                player.source=("sounds/not-bad-"+ pr_randomIndex + ".ogg")
                return ("images/not-bad-"+ pr_randomIndex + ".gif")
            }
            else{
                feedbackLabel.text= qsTr("okay")
                player.source=("sounds/okay-"+ pr_randomIndex + ".ogg")
                return ("images/okay-"+ pr_randomIndex + ".gif")
            }

        }

        height: 200
        width: 200
        anchors {
            top: answer.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 45
        }
        visible: false

    }
    AnimatedImage{
        id:wrongImage
        source: {

            if(pr_countWrong===1){
                feedbackLabel.text= qsTr("wrong")
                player.source=("sounds/okay-"+ pr_randomIndex + ".ogg")
                return ("images/wrong-anwser-"+ pr_randomIndex + ".gif")
            }
            else{
                feedbackLabel.text= qsTr("wrong-repeated")
                player.source=("sounds/wrong-anwser-repeted-"+ pr_randomIndex + ".ogg")
                return ("images/wrong-anwser-repeted-"+ (pr_randomIndex === 3 ? 1:pr_randomIndex)  + ".gif")
            }
        }
        height: 200
        width: 200
        anchors {
            top: answer.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 45
        }
        visible: false
    }

    //
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
    Button {
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

        Keys.onEnterPressed: {

        }
    }


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
                text: "Select Difficulty Level:"
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
                model: ["Simple" , "Easy", "Medium", "Hard", "Challenging"]
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
