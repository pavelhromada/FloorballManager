/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtGraphicalEffects 1.0

MouseArea {
    id: mouseArea

    property alias iconSource: image.source

    anchors.centerIn: parent
    height: 100
    width: height
    
    Image {
        id: image
        fillMode: Image.PreserveAspectFit
        anchors {
            centerIn: parent
            horizontalCenterOffset: mouseArea.pressed ? 1 : 0
            verticalCenterOffset: mouseArea.pressed ? 1 : 0
        }
        height: mouseArea.height - 10
    }
}
