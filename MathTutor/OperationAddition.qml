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
    property int pr_difficulty: 0
    property var pr_answer: 0
    // page up and  down to change the difficulty level
    property int pr_timeTaken: 0
    // a random value between 1-3
    property int pr_randomIndex: Math.floor(Math.random() * 3) + 1
    property int pr_countWrong : 0

    property var pr_opCompleted: bridge.opCompleted
    Component.onCompleted: {
        bridge.process_file("C:/Users/ronak kumbhat/Desktop/Book1.xlsx")
        bridge.nextQuestion()

        generateNextQuestion()
    }
    function generateNextQuestion(){
        question.text= qsTr(bridge.getOp1() + " + " + bridge.getOp2() + " = ")
        console.log("hh",(bridge.getOp1()*1 + bridge.getOp2()*1))
        bridge.nextQuestion()
    }
    onPr_opCompletedChanged: {
        console.log("hh",(bridge.getOp1()*1 + bridge.getOp2()*1))
       question.text= qsTr(bridge.getOp1() + " + " + bridge.getOp2() + " = ")
        bridge.nextQuestion()

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
        pr_timeTaken = 0
        pr_countWrong = 0
        pr_randomIndex = Math.floor(Math.random() * 3) + 1
        timerforQuestion.start()
        //generate random numbers according to diifculty level
        var num1 = Math.floor(Math.random() * 10) + 10
        var num2 = Math.floor(Math.random() * 10) + 10
        var num3 = Math.floor(Math.random() * 10) + 10
        var num4 = Math.floor(Math.random() * 10) + 10
        if(pr_difficulty === 0){
            // range from 10-20
            num1 = Math.floor(Math.random() * 10) + 10
            num2 = Math.floor(Math.random() * 10) + 10
            pr_answer = num1 + num2
            return num1 + " + " + num2 + " = "
        }
        else if(pr_difficulty === 1){
            // range from 20-30
            num1 = Math.floor(Math.random() * 10) + 20
            // range from 10 -20
            num2 = Math.floor(Math.random() * 10) + 10
            pr_answer = num1 + num2
            return num1 + " + " + num2 + " = "
        }
        else if( pr_difficulty === 2){
            // range from 30-50
            num1 = Math.floor(Math.random() * 20) + 30
            /// range from 20-30
            num2 = Math.floor(Math.random() * 10) + 20
            // range from 10-20
            num3 = Math.floor(Math.random() * 10) + 10
            pr_answer = num1 + num2 + num3
            return num1 + " + " + num2 + " + " + num3 + " = "


        }
        else if(pr_difficulty === 3){
            // range from 30-50
            num1 = Math.floor(Math.random() * 20) + 30
            //range from 20 -30
            num2 = Math.floor(Math.random() * 10) + 20
            // range from 10 - 20
            num3 = Math.floor(Math.random() * 10) + 10
            // range from 20-30
            num4 = Math.floor(Math.random() * 10) + 20
            pr_answer = num1 + num2 - (num3 / num4)
            return num1 + " + " + num2 + " - (  " + num3 + " /  " + num4 + " ) = "
        }
        else if(pr_difficulty === 4){
            // range from 30-50
            num1 = Math.floor(Math.random() * 20) + 30
            // range from 30-50
            num2 = Math.floor(Math.random() * 20) + 30
            // range from 10 - 20
            num3 = Math.floor(Math.random() * 10) + 10
            // range from 20-30
            num4 = Math.floor(Math.random() * 10) + 20
            pr_answer = num1 + num2 - (num3 / num4)
            return num1 + " + " + num2 + " - (  " + num3 + " /  " + num4 + " ) = "
        }
        else{
            // range from 30-50
            num1 = Math.floor(Math.random() * 20) + 30
            // range from 30-50
            num2 = Math.floor(Math.random() * 20) + 30
            // range from 10 - 20
            num3 = Math.floor(Math.random() * 10) + 10
            // range from 20-30
            num4 = Math.floor(Math.random() * 10) + 20
            pr_answer = num1 + num2 - (num3 / num4)
            return num1 + " + " + num2 + " - (  " + num3 + " /  " + num4 + " ) = "
        }
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

    Text {
        id: question
        text: generateQuestion()
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter

            topMargin: 250
        }
        font.pixelSize: pr_fontSizeMultiple +  30
        color: "orange"
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

    }

    Keys.onReturnPressed: {
        timerforQuestion.stop()
        console.log("Correct answer", pr_answer.toFixed(0).toString())
        console.log("User answer", answer.text,qsTr(answer.text + ".0"))
        if(answer.text.toString() === pr_answer.toFixed(0).toString() || qsTr((answer.text.toString() + ".0 ")) === pr_answer.toString()){
            animationImageExcellent.running = true
        }
        else{
            pr_countWrong++
            animationImageWrong.running = true
        }


    }
    Keys.onEnterPressed: {
        timerforQuestion.stop()

        console.log("Correct answer", pr_answer.toFixed(0).toString())
        console.log("User answer", answer.text,qsTr(answer.text + ".0"))
        if(answer.text.toString() === pr_answer.toFixed(0).toString() || qsTr((answer.text.toString() + ".0 ")) === pr_answer.toString()){
            animationImageExcellent.running = true
        }
        else{
            pr_countWrong++
            animationImageWrong.running = true
        }
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
            question.text = generateQuestion()
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
            answer.text = ""
        }
    }

    AnimatedImage {
        id: excellentImage
        source: {
            if(pr_timeTaken < 5){
                feedbackLabel.text= qsTr("Excellent")
                return ("images/excellent-"+ pr_randomIndex + ".gif")

            }
            else if(pr_timeTaken<10){
                feedbackLabel.text= qsTr("very-good")

                return ("images/very-good-"+ pr_randomIndex + ".gif")
            }
            else if(pr_timeTaken<15){
                feedbackLabel.text= qsTr("good")

                return ("images/good-"+ pr_randomIndex + ".gif")
            }
            else if(pr_timeTaken<15){
                feedbackLabel.text= qsTr("not-bad")

                return ("images/not-bad-"+ pr_randomIndex + ".gif")
            }
            else if(pr_timeTaken<20){
                feedbackLabel.text= qsTr("okay")

                return ("images/okay-"+ pr_randomIndex + ".gif")
            }

            else{
                return ""
            }

        }

        height: 200
        width: 200
        anchors {
            top: answer.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 10
        }
        visible: false

    }
    AnimatedImage{
        id:wrongImage
        source: {

            if(pr_countWrong===1)
                return ("images/wrong-anwser-"+ pr_randomIndex + ".gif")
            else
                return ("images/wrong-anwser-repeted-"+ (pr_randomIndex === 3 ? 1:pr_randomIndex)  + ".gif")

        }
        height: 200
        width: 200
        anchors {
            top: answer.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 10
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
                    if(root.pr_difficulty==0){
                        num1MinSpinBox.value = 10
                        num1MaxSpinBox.value = 20
                    }
                    else if(root.pr_difficulty==1){
                        num1MinSpinBox.value = 20
                        num1MaxSpinBox.value = 50
                    }
                    else if(root.pr_difficulty==2){
                        num1MinSpinBox.value = 50
                        num1MaxSpinBox.value = 75
                    }
                    else if(root.pr_difficulty==3){
                        num1MinSpinBox.value = 75
                        num1MaxSpinBox.value = 85
                    }
                    else if(root.pr_difficulty==4){
                        num1MinSpinBox.value = 85
                        num1MaxSpinBox.value = 100
                    }
                    
                }
            }

            // a spin box to define the range of num1
            Text{
                id: num1RangeText
                text: "Operand 1 Range:"
                anchors{
                    left: parent.left
                    leftMargin: 5
                    top: difficultySelectionText.bottom
                    topMargin: 70
                }
                color: Material.primaryTextColor
                font.pixelSize:  pr_fontSizeMultiple +  18

            }
            //lower bound
            SpinBox {
                id: num1MinSpinBox
                value: 10
                from: 0
                to: 100
                stepSize: 1

                anchors{
                    left: num1RangeText.left
                    leftMargin: 150
                    top: difficultyComboBox.bottom
                    topMargin: 25
                }
                onValueChanged: {
                    // root.pr_num1Min = num1MinSpinBox.value
                    // question.text = root.generateQuestion()
                }
            }
            //upper bound
            SpinBox {
                id: num1MaxSpinBox
                value: 20
                from: 0
                to: 100
                stepSize: 1
                anchors{
                    left: num1MinSpinBox.right
                    leftMargin: 10
                    top: difficultyComboBox.bottom
                    topMargin: 25
                }
                onValueChanged: {
                    // root.pr_num1Max = num1MaxSpinBox.value
                    // question.text = root.generateQuestion()
                }
            }


        }
    }
}
