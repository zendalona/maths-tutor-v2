# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial

import sys
from pathlib import Path

from PySide6.QtCore import QObject, Slot, QStringListModel, QUrl
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
    def __init__(self):
        QObject.__init__(self)
    a = "1"  # a variable that is exposed to qml

    @Slot( result=int)
    def getText(self):
        return self.a

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


if __name__ == '__main__':
    app = QGuiApplication(sys.argv)
    QQuickStyle.setStyle("Material")
    engine = QQmlApplicationEngine()
    app.setWindowIcon(QIcon("images\icon.png"));



    # Get the path of the current directory, and then add the name
    # of the QML file, to load it.
    qml_file = Path(__file__).parent / 'RootWindow.qml'
    #create a variable b=1 and expose it to qml
    b = 12
    engine.rootContext().setContextProperty("br", b)

    # #show the qml file

    engine.load(qml_file)



    # view = QQuickView()
    # view.setResizeMode(QQuickView.SizeRootObjectToView)
    # view.setSource(QUrl.fromLocalFile(qml_file.resolve()))
    # view.show()




    sys.exit(app.exec())
