// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial


import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1

import io.qt.textproperties 1.0

ApplicationWindow {
    id: page
    width: 1080
    height: 720
    visible: true
    Material.theme:welcomeScreen.theme ===1 ? Material.Dark : Material.Light
    Material.accent: Material.Red
    title: "Welcome Screen"
    WelcomeScreen{
        id: welcomeScreen
        height: parent.height
        width: parent.width
    }

}
