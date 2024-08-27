# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial

import sys
from pathlib import Path
import pandas as pd
import random
import string
from PySide6.QtCore import QObject, Slot, QStringListModel, QUrl , Signal , Property
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine, QmlElement
from PySide6.QtQuickControls2 import QQuickStyle
from PySide6.QtQuick import QQuickView
import openpyxl

#import style_rc

# To be used on the @QmlElement decorator
# (QML_IMPORT_MINOR_VERSION is optional)

QML_IMPORT_NAME = "io.qt.textproperties"
QML_IMPORT_MAJOR_VERSION = 1
@QmlElement


class Bridge(QObject):

    questionChanged = Signal()
    answerChanged = Signal()
    questionTypeChanged = Signal()
    difficultyIndexChanged = Signal()


    def __init__(self):
        super().__init__()

        self._a = [1, 2, 3, 4, 5]

        self.op1=1
        self.op2=2
        self.op3=""
        self.op4=""

        self.oprands=[]
        self.variables=[]
        self.questionIndex = 0
        self.difficultyIndex = 1
        self.questionType="addition"
        self.rowIndex = 0
        self.fileurl="C:/Users/ronak kumbhat/Desktop/Book1.xlsx"
        self.df=""

        self.question="default"

        self.answer="default"




    @Property(str, notify=questionChanged)
    def Pr_question(self):
        print("getter called")
        return self.question

    @Pr_question.setter
    def Pr_question(self, value):
        self.question=value
        self.questionChanged.emit()

    @Property(str, notify=answerChanged)
    def Pr_answer(self):
        return self.answer

    @Pr_answer.setter
    def Pr_answer(self, value):
        self.answer=value
        self.answerChanged.emit()

    @Property(str, notify=questionTypeChanged)
    def Pr_questionType(self):
        return self.questionType

    @Pr_questionType.setter
    def Pr_questionType(self, value):
        self.questionType=value
        self.questionTypeChanged.emit()

    @Property(int, notify=difficultyIndexChanged)
    def Pr_difficultyIndex(self):
        return self.difficultyIndex

    @Pr_difficultyIndex.setter
    def Pr_difficultyIndex(self, value):
        self.difficultyIndex= int(value)
        self.difficultyIndexChanged.emit()






    @Slot(result=str)
    def getfileurl(self):
        return self.fileurl
    @Slot(str)
    def appendValue(self, value):
        self._a.append(value)
        self.textChanged.emit()

    @Slot(result=list)
    def getText(self):
        return self._a

    @Slot(str)
    def displayText(self):
        print(self._a)


    @Slot(str, result=str)
    def getColor(self, s):
        if s.lower() == "red":
            return "#ef9a9a"
        elif s.lower() == "green":
            return "#a5d6a7"
        elif s.lower() == "blue":
            return "#90caf9"
        else:
            return "white"

    @Slot(float, result=int)
    def getSize(self, s):
        size = int(s * 34)
        if size <= 0:
            return 1
        else:
            return size

    @Slot(str, result=bool)
    def getItalic(self, s):
        if s.lower() == "italic":
            return True
        else:
            return False

    @Slot(str, result=bool)
    def getBold(self, s):
        if s.lower() == "bold":
            return True
        else:
            return False

    @Slot(str, result=bool)
    def getUnderline(self, s):
        if s.lower() == "underline":
            return True
        else:
            return False



    @Slot(result=int)
    def getOp1(self):
        return self.op1

    @Slot(result=int)
    def getOp2(self):
        return self.op2



    @Slot(str)
    def process_file(self, file_url):
        # Convert the file URL to a local file path if necessary
        print(f"file_url: {file_url}")
        local_file_path = file_url.replace("file:///", "")
        print(f"Processing file: {local_file_path}")
        # Read the Excel file
        self.df = pd.read_excel(local_file_path) # Read the Excel file
        self.df = pd.DataFrame(self.df)         # Convert the Excel file to a DataFrame
        self.df = self.df[self.df["type"] == self.questionType]  # Filter the DataFrame by the question type
        self.df = self.df.sort_values(by="difficulty", ascending=True)  # Sort the DataFrame by difficulty

        for i in range(len(self.df)):
            row = self.df.iloc[i]
            if(row["difficulty"] == self.difficultyIndex):
                self.rowIndex = i
                print(self.rowIndex,"rowIndex from for loop",self.df.iloc[i])
                break
        print(self.df)
        print(self.rowIndex,"rowIndex outside for loop ")

    @Slot()
    def sequence(self):
        self.getVariables()
        self.parseInput()
        self.extractQuestion()
        self.extractAnswer()

    @Slot()
    def incrementQuestionIndex(self):
        self.rowIndex = (self.rowIndex + 1) % len(self.df)
        self.oprands=[]
        self.variables=[]

    @Slot()
    def getVariables(self):
        self.variables = self.allVariables(self.rowIndex,2)
        print("variables are ",self.variables)

    @Slot()
    def parseInput(self):
        inputRange = self.removeVariables(self.rowIndex,2)
        print("ir",inputRange)
        self.parseInputRange(inputRange)


    @Slot()
    def extractQuestion(self):
        new_value = self.replaceVariables(self.rowIndex,0)
        print("nv",new_value)
        self.Pr_question = new_value

    @Slot()
    def extractAnswer(self):
        answerEquation =  self.getAnswer(self.rowIndex,4)
        finalAns=self.solveEquation(answerEquation)
        print("finalAns",finalAns)
        self.Pr_answer = str(finalAns)
        print("answer",self.Pr_answer)

    @Slot()
    def solveEquation(self,ansEquation):
        #solve the equation and return the answer

        return eval(ansEquation)

    @Slot()
    def getAnswer(self,row,column):
        ansEquation = self.df.iloc[row, column]

        print("ansEquation",ansEquation)
        for i in range(len(self.variables)):
            ansEquation = ansEquation.replace(('{'+self.variables[i]+'}'), str(self.oprands[i]))
        print("ansEquation",ansEquation)
        return ansEquation

    @Slot()
    def removeVariables(self,row,column):
        #remove all the alphabets from the string
        inputRange = self.df.iloc[row, column]
        tempstr=""
        for i in range(len(inputRange)):
            if(inputRange[i].isalpha()):
                continue
            else:
                tempstr += inputRange[i]
        inputRange = tempstr
        return inputRange

    @Slot()
    def replaceVariables(self,row,column):
        new_value = self.df.iloc[row, column]
        for i in range(len(self.variables)):
            new_value = new_value.replace(('{'+self.variables[i]+'}'), str(self.oprands[i]))
        return new_value


    @Slot()
    def allVariables(self,row,column):
        #find all the alphabet characters in the string
        #return the list of all the characters

        #take the string from column
        cell_value = self.df.iloc[row, column]
        #find all the alphabet characters in the cell_value
        l = []
        for i in range(len(cell_value)):
            if(cell_value[i].isalpha()):
                l.append(cell_value[i])
        print("vars",l)
        return l


    @Slot()
    def extractType(self,inputRange):
        #check if inputRange has , in it
        l1=[]
        if(inputRange.find(",") != -1):
            #covert the char into numbers and add them to l1 list
            a1=""
            for i in range(len(inputRange)):
                if(inputRange[i] != ","):
                    a1 += inputRange[i]
                else:
                    l1.append(int(a1))
                    a1=""
            l1.append(int(a1))
            #choose a random number from
            #return the number
            return l1[random.randint(0,len(l1)-1)]

        #check if inputRange has : in it
        elif(inputRange.find(":") != -1):
            #covert the char into numbers and add them to l1 list
            a2=""
            for i in range(len(inputRange)):
                if(inputRange[i] != ":"):
                    a2 += inputRange[i]
                else:
                    l1.append(int(a2))
                    a2=""
            l1.append(int(a2))
            #choose a random number between the first and last number in the list
            #return the number
            return random.randint(l1[0],l1[len(l1)-1])

        elif(inputRange.find(";") != -1):
            #covert the char into numbers and add them to l1 list
            a3=""
            for i in range(len(inputRange)):
                if(inputRange[i] != ";"):
                    a3 += inputRange[i]
                else:
                    l1.append(int(a3))
                    a3=""
            l1.append(int(a3))
            #choose a random multiple of first number  multiplied to the number between second number and third number
            #return the number
            return l1[0]*random.randint(l1[1],l1[2])



    @Slot()
    def parseInputRange(self,inputRange):
        t0 = ""
        for i in range(len(inputRange)):
            if(inputRange[i] == "*"):
                self.oprands.append(int(self.extractType(t0)))
                t0 = ""
            else:
                t0 += inputRange[i]
        print("oprands",self.oprands)








if __name__ == '__main__':
    app = QGuiApplication(sys.argv)
    QQuickStyle.setStyle("Material")
    engine = QQmlApplicationEngine()
    app.setWindowIcon(QIcon("images\icon.png"));



    # Get the path of the current directory, and then add the name
    # of the QML file, to load it.
    qml_file = Path(__file__).parent / 'RootWindow.qml'

    bridge=Bridge()

    engine.rootContext().setContextProperty("bridge", bridge)


    # #show the qml file

    engine.load(qml_file)

    sys.exit(app.exec())
