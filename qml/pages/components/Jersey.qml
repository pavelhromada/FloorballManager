/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.6
import QtGraphicalEffects 1.0

Item {
    id: root

    signal clicked

    property color color: "red"
    property string teamId: "A"

    implicitWidth: 300
    implicitHeight: 300

    Rectangle {
        color: Qt.darker( root.color, 1.4 )
        width: image.width * 0.34
        height: width
        anchors {
            top: image.top
            horizontalCenter: image.horizontalCenter
        }
    }

    Image {
        id: image
        anchors.centerIn: parent
        source: "../../../images/jersey.svg"
        sourceSize: Qt.size( parent.width, parent.height )
        smooth: true
        visible: false
     }

    ColorOverlay {
        anchors.fill: image
        source: image
        color: root.color
    }

    Rectangle {
        height: image.height * 0.05
        width: image.width * 0.6
        color: Qt.lighter( root.color )
        anchors {
            bottom: image.bottom
            horizontalCenter: image.horizontalCenter
            bottomMargin: image.height * 0.05
        }
    }

    Text {
        anchors {
            centerIn: image
            verticalCenterOffset: -image.height * 0.1
        }
        text: root.teamId
        color: Qt.darker( root.color )
        font {
            pixelSize: image.height / 3
            bold: true
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
