/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Templates 2.3 as T
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Material.impl 2.3

T.Pane {
    id: control

    property int goals: 0

    signal clicked

    implicitWidth: Math.max(background ? background.implicitWidth : 0, contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0, contentHeight + topPadding + bottomPadding)

    contentWidth: contentItem.implicitWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : 0)
    contentHeight: contentItem.implicitHeight || (contentChildren.length === 1 ? contentChildren[0].implicitHeight : 0)

    Material.elevation: 2

    padding: 12

    background: Rectangle {
        color: control.Material.backgroundColor
        radius: 4
        border {
            width: 1
            color: "lightgrey"
        }

        layer.enabled: control.enabled && control.Material.elevation > 0
        layer.effect: ElevationEffect {
            elevation: control.Material.elevation
        }

        Text {
            id: goalsText
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Math.min( control.width, control.height ) * 0.8
            text: control.goals > 9 ? control.goals : "0" + control.goals
        }
    }

    // left hole
    Rectangle {
        id: leftHole
        color: "darkgrey"
        width: 22
        radius: width / 2
        height: width
        anchors {
            centerIn: parent
            verticalCenterOffset: -control.height * 0.45
            horizontalCenterOffset: -control.width * 0.2
        }
    }

    // left hande
    Rectangle {
        color: "black"
        width: 16
        radius: 4
        height: (control.height / 2 - control.height * 0.45) * 2.2
        anchors {
            horizontalCenter: leftHole.horizontalCenter
            bottom: leftHole.top
            bottomMargin: -leftHole.height * 0.4
        }
    }

    // right hole
    Rectangle {
        id: rightHole
        color: "darkgrey"
        width: 22
        radius: width / 2
        height: width
        anchors {
            centerIn: parent
            verticalCenterOffset: -control.height * 0.45
            horizontalCenterOffset: control.width * 0.2
        }
    }

    // right hande
    Rectangle {
        color: "black"
        width: 16
        radius: 4
        height: (control.height / 2 - control.height * 0.45) * 2.2
        anchors {
            horizontalCenter: rightHole.horizontalCenter
            bottom: rightHole.top
            bottomMargin: -rightHole.height * 0.4
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: control.clicked()
    }
}
