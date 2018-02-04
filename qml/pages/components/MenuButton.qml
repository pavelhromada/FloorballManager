/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

Pane {
    id: root
    
    property alias title: titleLabel.text
    property alias iconSource: icon.source
    
    signal clicked
    
    implicitWidth: 360
    implicitHeight: 180
    
    Material.elevation: mouseArea.pressed ? 2 : 1
    
    RowLayout {
        spacing: height * 0.3
        anchors {
            fill: parent
            leftMargin: root.height * 0.2
        }
        
        Image {
            id: icon
            Layout.preferredHeight: root.height * 0.6
            Layout.preferredWidth: root.height * 0.6
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            fillMode: Image.PreserveAspectFit
        }
        
        Label {
            id: titleLabel
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: root.height * 0.2
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
