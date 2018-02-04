/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

ToolBar {
    property alias title: titleLabel.text
    property bool backButtonVisible: true
    property Action pageAction

    Material.foreground: "white"
    
    RowLayout {
        spacing: 20
        anchors.fill: parent
        
        ToolButton {
            visible: backButtonVisible
            contentItem: Image {
                fillMode: Image.Pad
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source: "../../../images/back.png"
            }

            onClicked: goBack()
        }
        
        Label {
            id: titleLabel

            font.pixelSize: 20
            elide: Label.ElideRight
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            Layout.fillWidth: true
        }

        ToolButton {
            visible: pageAction != undefined
            action: pageAction
        }
    }
}
