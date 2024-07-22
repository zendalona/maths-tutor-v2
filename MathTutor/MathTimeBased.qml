import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1
import QtMultimedia
import io.qt.textproperties 1.0

Item {
    id: root
    property int  pr_hr: 12
    property int  pr_min: 30
    property int  pr_x: 10
    property int  pr_difficulty: 0

    Component.onCompleted: {
        generateQuestion()
    }

    //a func to generate question based on difficulty level
    function generateQuestion(){
        // Generate random values based on difficulty level
        if (pr_difficulty === 0) {
            // range from 10-19
            pr_hr = Math.floor(Math.random() * 10) + 10;
            // range from 10-19
            pr_min = Math.floor(Math.random() * 10) + 10;
            // range from 10-19
            pr_x = Math.floor(Math.random() * 10) + 10;
        } else if (pr_difficulty === 1) {
            // range from 20-29
            pr_hr = Math.floor(Math.random() * 10) + 20;
            // range from 10-19
            pr_min = Math.floor(Math.random() * 10) + 10;
            // range from 10-19
            pr_x = Math.floor(Math.random() * 10) + 10;
        } else if (pr_difficulty === 2) {
            // range from 30-49
            pr_hr = Math.floor(Math.random() * 20) + 30;
            // range from 20-29
            pr_min = Math.floor(Math.random() * 10) + 20;
            // range from 10-19
            pr_x = Math.floor(Math.random() * 10) + 10;
        } else if (pr_difficulty === 3) {
            // range from 30-49
            pr_hr = Math.floor(Math.random() * 20) + 30;
            // range from 20-29
            pr_min = Math.floor(Math.random() * 10) + 20;
            // range from 10-19
            pr_x = Math.floor(Math.random() * 10) + 10;
        } else if (pr_difficulty === 4) {
            // range from 30-49
            pr_hr = Math.floor(Math.random() * 20) + 30;
            // range from 30-49
            pr_min = Math.floor(Math.random() * 20) + 30;
            // range from 10-19
            pr_x = Math.floor(Math.random() * 10) + 10;
        } else {
            // Default case
            // range from 30-49
            pr_hr = Math.floor(Math.random() * 20) + 30;
            // range from 30-49
            pr_min = Math.floor(Math.random() * 20) + 30;
            // range from 10-19
            pr_x = Math.floor(Math.random() * 10) + 10;
        }

        // Ensure minutes are within 0-59
        pr_min = pr_min % 60;

        // Ensure hours are within 0-23
        pr_hr = pr_hr % 24;
        time.text= "If the current time is "+pr_hr+":"+pr_min+" , what will be the time after "+pr_x+" minutes ?"

    }

    //check answer
    function isAnswerCorrect(pr_hr, pr_min, user_answer) {
        // Parse input values
        let currentHours = parseInt(pr_hr);
        let currentMinutes = parseInt(pr_min);
        let additionalMinutes = parseInt(pr_x);

        // Calculate the new time
        let totalMinutes = currentMinutes + additionalMinutes;
        let newHours = currentHours + Math.floor(totalMinutes / 60);
        let newMinutes = totalMinutes % 60;
        newHours = newHours % 24;

        // Format the new time as HH:MM
        let formattedHours = newHours.toString().padStart(2, '0');
        let formattedMinutes = newMinutes.toString().padStart(2, '0');
        let correctAnswer = formattedHours + ':' + formattedMinutes;

        // Check if the user's answer is correct
        return correctAnswer === user_answer;
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
                id: inputhr
                placeholderText: "hr"
                font.pixelSize: pr_fontSizeMultiple +  20

            }
            TextField{
                id: inputmin
                placeholderText: "min"
                font.pixelSize: pr_fontSizeMultiple +  20
            }
            Button{
                id: submit
                text: "Submit"
                onClicked: {
                    if(isAnswerCorrect(pr_hr, pr_min, inputhr.text + ':' + inputmin.text)){
                        animationImageExcellent.running = true
                    }
                    else {
                        animationImageWrong.running = true
                        wrongImage.visible = true
                    }
                }
                Keys.onReturnPressed:{
                    if(isAnswerCorrect(pr_hr, pr_min, inputhr.text + ':' + inputmin.text)){
                        animationImageExcellent.running = true
                    }
                    else {
                        animationImageWrong.running = true
                        wrongImage.visible = true
                    }
                }

                Keys.onEnterPressed: {
                    if(isAnswerCorrect(pr_hr, pr_min, inputhr.text + ':' + inputmin.text)){
                        animationImageExcellent.running = true
                    }
                    else {
                        animationImageWrong.running = true
                        wrongImage.visible = true
                    }
                }
            }
        }
        AnimatedImage {
            id: excellentImage
            source: "images/excellent-1.gif"
            height: 200
            width: 200
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            visible: false
        }
        AnimatedImage {
            id: wrongImage
            source: "images/wrong-anwser-1.gif"
            height: 200
            width: 200
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            visible: false
        }
        // a help button in the corner
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
            inputhr.text = ""
            inputmin.text = ""

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
            inputhr.text = ""
            inputmin.text = ""

        }
    }
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
        id: timeSettingsButton
        text: "Settings"
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 10
            bottomMargin:  10
        }
        onClicked: {
            timesettingsWindow.visible = true
        }
        Keys.onReturnPressed:{
            timesettingsWindow.visible = true
        }

        Keys.onEnterPressed: {
            timesettingsWindow.visible = true
        }
    }
    ApplicationWindow {
        id: timesettingsWindow
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
