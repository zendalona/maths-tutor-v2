import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0

Item {
    id: root
    property int  pr_x:10
    property int  pr_y:5
    property int  pr_difficulty: 0
    // page up and  down to change the difficulty level
    property int pr_timeTaken: 0
    // a random value between 1-3
    property int pr_randomIndex: Math.floor(Math.random() * 3) + 1
    property int pr_countWrong : 0
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

    Component.onCompleted: {
        generateQuestion()
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
    //a func to generate question based on difficulty level
    function generateQuestion(){
        pr_timeTaken = 0
        pr_countWrong = 0
        pr_randomIndex = Math.floor(Math.random() * 3) + 1
        timerforQuestion.start()
        // Generate random values based on difficulty level
        if (pr_difficulty === 0) {
            // range from 10-19
            pr_x = Math.floor(Math.random() * 10) + 10;
            // range from 10-19
            pr_y = Math.floor(Math.random() * 10) + 10;
        } else if (pr_difficulty === 1) {
            // range from 20-29
            pr_x = Math.floor(Math.random() * 10) + 20;
            // range from 10-19
            pr_y = Math.floor(Math.random() * 10) + 10;
        } else if (pr_difficulty === 2) {
            // range from 30-49
            pr_x = Math.floor(Math.random() * 20) + 30;
            // range from 20-29
            pr_y = Math.floor(Math.random() * 10) + 20;
        } else if (pr_difficulty === 3) {
            // range from 30-49
            pr_x = Math.floor(Math.random() * 20) + 30;
            // range from 20-29
            pr_y = Math.floor(Math.random() * 10) + 20;
        } else if (pr_difficulty === 4) {
            // range from 30-49
            pr_x = Math.floor(Math.random() * 20) + 30;
            // range from 30-49
            pr_y = Math.floor(Math.random() * 20) + 30;
        } else {
            // Default case
            // range from 30-49
            pr_x = Math.floor(Math.random() * 20) + 30;
            // range from 30-49
            pr_y = Math.floor(Math.random() * 20) + 30;
        }

        if(pr_x < pr_y){
            var temp = pr_x
            pr_x = pr_y
            pr_y = temp
        }

        // Display the question
        time.text= "If you had "+pr_x+" Rs and paid "+pr_y+" Rs. How much money is left with you ?"

    }

    //check answer
    function isAnswerCorrect(x, y, answer){
        return Math.abs(x-y) === parseInt(answer)
    }

    Column{
        anchors{
            top: parent.top
            topMargin: 200
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 20
        Text {
            id: time
            font.pixelSize: pr_fontSizeMultiple +  30
            color: Material.primaryTextColor
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors{
                horizontalCenter: parent.horizontalCenter
            }
        }
        Row{
            id: userinput
            anchors{
                horizontalCenter: parent.horizontalCenter
            }
            spacing: 10
            TextField {
                id: inputUserAnswer
                placeholderText: "answer"
                font.pixelSize: pr_fontSizeMultiple +  20

            }
            Button{
                id: submit
                text: "Submit"
                onClicked: {
                    timerforQuestion.stop()

                    if(isAnswerCorrect(pr_x, pr_y, inputUserAnswer.text )){
                        animationImageExcellent.running = true
                    }
                    else {
                        pr_countWrong++

                        animationImageWrong.running = true
                        wrongImage.visible = true
                    }
                }
                Keys.onReturnPressed:{
                    timerforQuestion.stop()

                    if(isAnswerCorrect(pr_x, pr_y, inputUserAnswer.text )){
                        animationImageExcellent.running = true
                    }
                    else {
                        pr_countWrong++

                        animationImageWrong.running = true
                        wrongImage.visible = true
                    }
                }

                Keys.onEnterPressed: {
                    timerforQuestion.stop()

                    if(isAnswerCorrect(pr_x, pr_y, inputUserAnswer.text )){
                        animationImageExcellent.running = true
                    }
                    else {
                        pr_countWrong++

                        animationImageWrong.running = true
                        wrongImage.visible = true
                    }
                }
            }
        }
        AnimatedImage {
            id: excellentImage
            source: {
                if(pr_timeTaken < 5){
                    return ("images/excellent-"+ pr_randomIndex + ".gif")
                }
                else if(pr_timeTaken<10){
                    return ("images/very-good-"+ pr_randomIndex + ".gif")
                }
                else if(pr_timeTaken<15){
                    return ("images/good-"+ pr_randomIndex + ".gif")
                }
                else if(pr_timeTaken<15){
                    return ("images/not-bad-"+ pr_randomIndex + ".gif")
                }
                else if(pr_timeTaken<20){
                    return ("images/okay-"+ pr_randomIndex + ".gif")
                }

                else{
                    return ""
                }

            }
            height: 200
            width: 200
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            visible: false
        }
        AnimatedImage {
            id: wrongImage
            source: {

                if(pr_countWrong===1)
                    return ("images/wrong-anwser-"+ pr_randomIndex + ".gif")
                else
                    return ("images/wrong-anwser-repeted-"+ (pr_randomIndex === 3 ? 1:pr_randomIndex)  + ".gif")

            }
            height: 200
            width: 200
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            visible: false
        }
        // 
    }
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
            loops: 1
        }
        onStopped: {
            animationImageExcellent.running = false
            generateQuestion()
            inputUserAnswer.text = ""


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
            loops: 1
        }
        onStopped: {
            animationImageWrong.running = false
            inputUserAnswer.text = ""


        }
    }
    Button {
        id: helpButton;visible:false
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
        id: currencySettingsButton
        text: "Settings"
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 10
            bottomMargin:  10
        }
        onClicked: {
            currencySettingsWindow.visible = true
        }
        Keys.onReturnPressed:{
            currencySettingsWindow.visible = true
        }

        Keys.onEnterPressed: {
            currencySettingsWindow.visible = true
        }
    }
    ApplicationWindow {
        id: currencySettingsWindow
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
                    root.generateQuestion()

                }

            }

        }
    }

}
