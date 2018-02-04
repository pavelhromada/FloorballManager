/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3

Item {
    id: root

    property color color: "#4e9ce4"
    property alias leftField: leftFieldComponent.data
    property alias rightField: rightFieldComponent.data
    property alias fullLeftField: fullLeftFieldComponent.data
    property alias fullRightField: fullRightFieldComponent.data
    property bool leftFieldHigherZ: false
    property int lineWidth: 2
    property color lineColor: Qt.tint( "white", "#704e9ce4" )
    property bool goalmouthVisible: true
    readonly property bool isHorizontal: width > height
    readonly property int circleWidth: centerCircle.width
    property alias teamAColor: teamAJersey.color
    property alias teamBColor: teamBJersey.color
    property alias centerCircleContent: centerCircle.data

    implicitHeight: 640
    implicitWidth: 480

    Image {
        anchors.fill: parent
        source: "../../../images/wood-texture.jpg"
        fillMode: Image.Tile
    }

    Rectangle {
        id: courtArea

        anchors {
            fill: parent
            margins: 15 + sentinelArea.border.width
        }
        color: root.color
        radius: sentinelArea.radius
    }

    Rectangle {
        id: sentinelArea
        anchors {
            fill: parent
            margins: 16
        }
        color: "transparent"
        radius: isHorizontal ? width * 0.08 : height * 0.08
        border {
            width: lineWidth
            color: "white"
        }
    }

    Item {
        anchors {
            fill: parent
            margins: 16
        }

        Jersey {
            id: teamAJersey
            color: "#00ff06"
            teamId: "A"
            height: isHorizontal ? leftGoalmouth.height : leftGoalmouth.width
            width: isHorizontal ? leftGoalmouth.width : leftGoalmouth.height
            anchors {
                centerIn: leftGoalmouth
                verticalCenterOffset: isHorizontal ? -sentinelArea.height / 4 : 0
                horizontalCenterOffset: isHorizontal ? 0 : -sentinelArea.width / 4
            }

            onClicked: {
                colorDialog.teamAColorSelection = true
                colorDialog.setValueFromColor( color )
                colorDialog.open()
            }
        }

        Goalmouth {
            id: leftGoalmouth

            lineWidth: root.lineWidth
            lineColor: root.lineColor
            positionLeft: true
            height: isHorizontal ? parent.height * 0.2 : parent.height * 0.07
            width: isHorizontal ? parent.width * 0.07 : parent.width * 0.2

            anchors {
                centerIn: parent
                verticalCenterOffset: isHorizontal ? 0 : (parent.height / 2) * 0.95 - height / 2
                horizontalCenterOffset: isHorizontal ? -((parent.width / 2) * 0.95 - width / 2) : 0
            }
        }

        Jersey {
            id: teamBJersey
            color: "#0000ff"
            teamId: "B"
            height: isHorizontal ? rightGoalmouth.height : rightGoalmouth.width
            width: isHorizontal ? rightGoalmouth.width : rightGoalmouth.height
            anchors {
                centerIn: rightGoalmouth
                verticalCenterOffset: isHorizontal ? -sentinelArea.height / 4 : 0
                horizontalCenterOffset: isHorizontal ? 0 : -sentinelArea.width / 4
            }

            onClicked: {
                colorDialog.teamAColorSelection = false
                colorDialog.setValueFromColor( color )
                colorDialog.open()
            }
        }

        Goalmouth {
            id: rightGoalmouth

            lineWidth: root.lineWidth
            lineColor: root.lineColor
            positionLeft: false
            height: isHorizontal ? parent.height * 0.2 : parent.height * 0.07
            width: isHorizontal ? parent.width * 0.07 : parent.width * 0.2

            anchors {
                centerIn: parent
                verticalCenterOffset: isHorizontal ? 0 : -((parent.height / 2) * 0.95 - height / 2)
                horizontalCenterOffset: isHorizontal ? (parent.width / 2) * 0.95 - width / 2 : 0
            }
        }

        // center line
        Rectangle {
            anchors.centerIn: parent
            width: isHorizontal ? lineWidth : parent.width - 2 * lineWidth
            height: isHorizontal ? parent.height - 2 * lineWidth : lineWidth
            color: lineColor
        }

        // center circle
        Rectangle {
            id: centerCircle

            anchors.centerIn: parent
            width: isHorizontal ? parent.height * 0.22 : parent.width * 0.22
            height: width
            radius: width / 2
            color: root.color
            border {
                width: lineWidth
                color: lineColor
            }
        }

        Cross {
            thickness: lineWidth
            color: lineColor
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: sentinelArea.radius * 0.6
                topMargin: sentinelArea.radius * 0.6
            }
        }

        Cross {
            thickness: lineWidth
            color: lineColor
            anchors {
                left: parent.left
                bottom: parent.bottom
                leftMargin: sentinelArea.radius * 0.6
                bottomMargin: sentinelArea.radius * 0.6
            }
        }

        Cross {
            thickness: lineWidth
            color: lineColor
            anchors {
                right: parent.right
                top: parent.top
                rightMargin: sentinelArea.radius * 0.6
                topMargin: sentinelArea.radius * 0.6
            }
        }

        Cross {
            thickness: lineWidth
            color: lineColor
            anchors {
                right: parent.right
                bottom: parent.bottom
                rightMargin: sentinelArea.radius * 0.6
                bottomMargin: sentinelArea.radius * 0.6
            }
        }

        Cross {
            thickness: lineWidth
            color: lineColor
            anchors {
                centerIn: parent
                verticalCenterOffset: isHorizontal ? -(parent.height / 2 - sentinelArea.radius * 0.6) : 0
                horizontalCenterOffset: isHorizontal ? 0 : -(parent.width / 2 - sentinelArea.radius * 0.6)
            }
        }

        Cross {
            thickness: lineWidth
            color: lineColor
            anchors {
                centerIn: parent
                verticalCenterOffset: isHorizontal ? parent.height / 2 - sentinelArea.radius * 0.6 : 0
                horizontalCenterOffset: isHorizontal ? 0 : parent.width / 2 - sentinelArea.radius * 0.6
            }
        }

        Item {
            id: fullLeftFieldComponent
            anchors {
                left: parent.left
                right: isHorizontal ? parent.horizontalCenter : parent.right
                top: isHorizontal ? parent.top : parent.verticalCenter
                bottom: parent.bottom
            }
        }

        Item {
            id: fullRightFieldComponent
            anchors {
                left: isHorizontal ? parent.horizontalCenter : parent.left
                right: parent.right
                top: parent.top
                bottom: isHorizontal ? parent.bottom : parent.verticalCenter
            }
        }

        Item {
            id: leftFieldComponent
            z: leftFieldHigherZ ? rightFieldComponent.z + 1 : rightFieldComponent.z - 1
            anchors {
                left: isHorizontal ? leftGoalmouth.right : parent.left
                right: isHorizontal ? centerCircle.left : parent.right
                top: isHorizontal ? parent.top : centerCircle.bottom
                bottom: isHorizontal ? parent.bottom : leftGoalmouth.top
            }
        }

        Item {
            id: rightFieldComponent
            anchors {
                left: isHorizontal ? centerCircle.right : parent.left
                right: isHorizontal ? rightGoalmouth.left : parent.right
                top: isHorizontal ? parent.top : rightGoalmouth.bottom
                bottom: isHorizontal ? parent.bottom : centerCircle.top
            }
        }
    }

    Dialog {
        id: colorDialog

        property bool teamAColorSelection: true

        function setValueFromColor( colorValue ) {
            colorSlider.setValueFromColor( colorValue )
        }

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        parent: ApplicationWindow.overlay
        width: 340
        contentHeight: colorSlider.realHeight
        focus: true
        modal: true
        title: "Please choose a color"
        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: {
            if (teamAColorSelection)
                teamAJersey.color = colorSlider.color
            else
                teamBJersey.color = colorSlider.color
        }

        onRejected: forceStackViewFocus()

        ColorSlider {
            id: colorSlider
            anchors.bottom: parent.bottom
            width: parent.width
        }
    }
}
