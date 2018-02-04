/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtGraphicalEffects 1.0

Item {
    id: root

    property alias source: img.source
    property alias fillMode: img.fillMode
    property alias border: borderRectangle
    property alias cached: img.cache

    Image {
        id: img
        anchors.centerIn: parent
        width: Math.min( parent.width, parent.height )
        height: width
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size( width, height )
        smooth: true
        visible: false
    }

    Rectangle {
        id: mask
        visible: false
        anchors.centerIn: parent
        width: Math.min( root.width, root.height )
        height: width
        radius: Math.min( width, height )
    }

    OpacityMask {
        anchors.fill: img
        source: img
        maskSource: mask
    }

    Rectangle {
        id: borderRectangle
        anchors.fill: img
        color: "transparent"
        radius: width
        border {
            color: "white"
            width: 2
        }
    }
}
