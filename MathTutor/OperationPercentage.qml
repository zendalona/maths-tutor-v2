import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0
import QtQml.Models 2.15
import QtQuick.Dialogs


Item {
    id: root
    property int pr_difficulty: 0
    property var pr_answer: 0
    function generateQuestion(){
        //generate random numbers according to diifculty level
        var num1 = Math.floor(Math.random() * 10) + 10
        var num2 = Math.floor(Math.random() * 10) + 10
        var num3 = Math.floor(Math.random() * 10) + 10
        var num4 = Math.floor(Math.random() * 10) + 10
        if(pr_difficulty === 0){
            // range from 10-20
            num1 = Math.floor(Math.random() * 10) + 10
            num2 = Math.floor(Math.random() * 10) + 10
            pr_answer = (num1 / num2)*100
            return num1 + " of " + num2 + " = "
        }
        else if(pr_difficulty === 1){
            // range from 20-30
            num1 = Math.floor(Math.random() * 10) + 20
            // range from 10 -20
            num2 = Math.floor(Math.random() * 10) + 10
            pr_answer = (num1 / num2)*100
            return num1 + " of " + num2 + " = "
        }
        else if( pr_difficulty === 2){
            // range from 30-50
            num1 = Math.floor(Math.random() * 20) + 30
            /// range from 20-30
            num2 = Math.floor(Math.random() * 10) + 20
            // range from 10-20
            num3 = Math.floor(Math.random() * 10) + 10
            pr_answer = ((num1 / num2) / num3)*100
            return num1 + " / " + num2 + " of " + num3 + " = "


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
            pr_answer = (num1 / (num2 - (num3 / num4)))*100
            return num1 + " of " + num2 + " - (  " + num3 + " /  " + num4 + " ) = "
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
            pr_answer = (num1 / (num2 - (num3 / num4)))*100
            return num1 + " of " + num2 + " - (  " + num3 + " /  " + num4 + " ) = "
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
            pr_answer = (num1 / (num2 - (num3 / num4)))*100
            return num1 + " of " + num2 + " - (  " + num3 + " /  " + num4 + " ) = "
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

    Keys.onReturnPressed: {
        console.log("Correct answer", pr_answer.toFixed(0).toString())
        console.log("User answer", answer.text,qsTr(answer.text + ".0"))
        if(answer.text.toString() === pr_answer.toFixed(0).toString() || qsTr((answer.text.toString() + ".0 ")) === pr_answer.toString()){
            animationImageExcellent.running = true
        }
        else{
            animationImageWrong.running = true
        }


    }
    Keys.onEnterPressed: {
        console.log("Correct answer", pr_answer.toFixed(0).toString())
        console.log("User answer", answer.text,qsTr(answer.text + ".0"))
        if(answer.text.toString() === pr_answer.toFixed(0).toString() || qsTr((answer.text.toString() + ".0 ")) === pr_answer.toString()){
            animationImageExcellent.running = true
        }
        else{
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
        source: "images/excellent-1.gif"
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
        source: "images/wrong-anwser-1.gif"
        height: 200
        width: 200
        anchors {
            top: answer.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 10
        }
        visible: false
    }

    // a help button in the corner
    Button {
        id: helpButton
        text: "Help"
        anchors {
            right: parent.right
            top: parent.top
            rightMargin: 10
            topMargin: 10
        }
        onClicked: {
            console.log("Help button clicked")
        }
        Keys.onReturnPressed:{

        }

        Keys.onEnterPressed: {

        }
    }
    Button{
        id: percentageSettingsButton
        text: "Settings"
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 10
            bottomMargin:  10
        }
        onClicked: {
            percentagesettingsWindow.visible = true
        }
        Keys.onReturnPressed:{
            percentagesettingsWindow.visible = true
        }

        Keys.onEnterPressed: {
            percentagesettingsWindow.visible = true
        }
    }
    // a upload button to upload the range of numbers to be used
    //the uploaded file should be a json file
    Button {
        id: uploadButton
        text: "Upload"
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 10
            bottomMargin: 10
        }
        onClicked: {
            console.log("Upload button clicked")
            fileDialog.open()
        }
        Keys.onReturnPressed:{

        }

        Keys.onEnterPressed: {

        }
    }
    FileDialog {
        id: fileDialog
        title: "Please choose a file"
       // folder: shortcuts.home
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrls)
            setRangeOfNumbers()
            close()
        }
        onRejected: {
            console.log("Canceled")
            close()
        }
        Component.onCompleted: {
            close()
        }
    }
    //use the file uploaded in FileDialog to set the range of numbers to be used
    //the file should be a json file
    //the json file should have the following format
    // {
    //     "min": 10,
    //     "max": 20
    // }
    function setRangeOfNumbers(){
        //read the file
        //set the range of numbers to be used
        var jsonFile = fileDialog.fileUrl
        console.log("jsonFile", jsonFile)
        var json = JSON.parse(jsonFile)
        console.log("json", json)

    }
    ApplicationWindow {
        id: percentagesettingsWindow
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
