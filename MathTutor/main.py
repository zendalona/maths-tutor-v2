# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial

import sys
from pathlib import Path
import pandas as pd
import random

from PySide6.QtCore import QObject, Slot, QStringListModel, QUrl , Signal , Property
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine, QmlElement
from PySide6.QtQuickControls2 import QQuickStyle
from PySide6.QtQuick import QQuickView

#import style_rc

# To be used on the @QmlElement decorator
# (QML_IMPORT_MINOR_VERSION is optional)

QML_IMPORT_NAME = "io.qt.textproperties"
QML_IMPORT_MAJOR_VERSION = 1
@QmlElement


class Bridge(QObject):

    textChanged = Signal()

    opChanged = Signal()


    updateData = Signal(list)  # Emit data as a list




    def __init__(self):
        super().__init__()
        self._a = [1, 2, 3, 4, 5]

        self.df=""

        self.op1=1
        self.op2=2
        self.op3=""
        self.op4=""

        self.questionIndex = 0

        self._opCompleted = 0

    @Property(int, notify=opChanged)
    def opCompleted(self):
        return self._opCompleted




    @Property(list, notify=textChanged)
    def a(self):
        return self._a

    @a.setter
    def asetter(self, value):
        self._a=value
        self.textChanged.emit()

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
        self.df = pd.read_excel(local_file_path)
        self.df = self.df.sort_values(by=self.df.columns[1])

        print(self.df)
        self.nextQuestion()

    def parseInputRange(self,inputRange):
        #save the string from inputRange into a var until * is hit
        t1 = ""
        for i in range(len(inputRange)):
            if(inputRange[i] == "*"):
                break
            else:
                t1 += inputRange[i]

        t2 = ""
        for i in range(len(t1)+1,len(inputRange)):
            if(inputRange[i] == "*"):
                break
            else:
                t2 += inputRange[i]
        t3 = ""
        for i in range(len(t1)+len(t2)+2,len(inputRange)):
            if(inputRange[i] == "*"):
                break
            else:
                t3 += inputRange[i]
        print("t1",t1)
        print("t2",t2)
        print("t3",t3)
        l1=[]
        #check if t1 has , in it
        if(t1.find(",") != -1):
            #covert the char into numbers and add them to l1 list
            a1=""
            for i in range(len(t1)):
                if(t1[i] != ","):
                    a1 += t1[i]
                else:
                    l1.append(int(a1))
                    a1=""
            l1.append(int(a1))
        #choose a random number from the list
        #return the number
        self.op1= l1[random.randint(0,len(l1)-1)]
        print("op1",self.op1)

        l2=[]
        #check if t2 has : in it
        if(t2.find(":") != -1):
            #covert the char into numbers and add them to l1 list
            a2=""
            for i in range(len(t2)):
                if(t2[i] != ":"):
                    a2 += t2[i]
                else:
                    l2.append(int(a2))
                    a2=""
            l2.append(int(a2))
        print("l2",l2)
        #choose a random number between the first and last number in the list
        #return the number
        self.op2= random.randint(l2[0],l2[len(l2)-1])
        print("op2",self.op2)

        l3=[]
        #check if t3 has ; in it

        if(t3.find(";") != -1):
            #covert the char into numbers and add them to l1 list
            a3=""
            for i in range(len(t3)):
                if(t3[i] != ";"):
                    a3 += t3[i]
                else:
                    l3.append(int(a3))
                    a3=""
            l3.append(int(a3))
        #choose a random multiple of first number  multiplied to the number between second number and third number
        #return the number
        self.op3= l3[0]*random.randint(l3[1],l3[2])
        print("op3",self.op3)


        self._opCompleted = 1

    @Slot()
    def nextQuestion(self):
        self._opCompleted = 0

        if len(self.df) > self.questionIndex:
            num_columns = 2#self.df.shape[1]  # Number of columns
            self.parseInputRange(self.df.iloc[self.questionIndex, 0])

            # if(num_columns ==1):
            #     self.op1 = str(self.df.iloc[self.questionIndex, 0])

            #     self.op2 = ""
            #     self.op3 = ""
            #     self.op4 = ""
            # elif(num_columns ==2):
            #     self.parseInputRange(self.df.iloc[self.questionIndex, 0])
            #     # self.op1 = str(self.df.iloc[self.questionIndex, 0])
            #     # self.op2 = str(self.df.iloc[self.questionIndex, 1])
            #     # self.op3 = ""
            #     # self.op4 = ""
            # elif(num_columns ==3):
            #     self.op1 = str(self.df.iloc[self.questionIndex, 0])
            #     self.op2 = str(self.df.iloc[self.questionIndex, 1])
            #     self.op3 = self.df.iloc[self.questionIndex, 2]
            #     self.op4 = ""
            # elif(num_columns ==4):
            #     self.op1 = str(self.df.iloc[self.questionIndex, 0])
            #     self.op2 = str(self.df.iloc[self.questionIndex, 1])
            #     self.op3 = self.df.iloc[self.questionIndex, 2]
            #     self.op4 = self.df.iloc[self.questionIndex, 3]
            # else:
            #     self.op1 = ""
            #     self.op2 = ""
            #     self.op3 = ""
            #     self.op4 = ""
            self.questionIndex = (self.questionIndex + 1) % len(self.df)

            print(self.op1)
            print(self.op2)
            print(self.op3)
            print(self.op4)
            print(self.questionIndex)


if __name__ == '__main__':
    app = QGuiApplication(sys.argv)
    QQuickStyle.setStyle("Material")
    engine = QQmlApplicationEngine()
    app.setWindowIcon(QIcon("images\icon.png"));



    # Get the path of the current directory, and then add the name
    # of the QML file, to load it.
    qml_file = Path(__file__).parent / 'RootWindow.qml'

    bridge=Bridge()

    bridge.textChanged.connect(bridge.displayText)

    engine.rootContext().setContextProperty("bridge", bridge)


    # #show the qml file

    engine.load(qml_file)

    sys.exit(app.exec())
