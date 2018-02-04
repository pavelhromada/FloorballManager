/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.0

Slider {
    id: control

    readonly property color color: Qt.hsla( value, 1.0, 0.5, 1.0 )
    readonly property int realHeight: handleComponent.height * 2.5 + handleComponent.implicitHeight + 4

    function setValueFromColor( colorValue ) {
        value = colorValue.hslHue
    }

//    implicitWidth: Math.max(background ? background.implicitWidth : 0,
//                                         (handle ? handle.implicitWidth : 0) + leftPadding + rightPadding)
//    implicitHeight: handleComponent.height * 2.5 + handleComponent.implicitHeight + 4
    value: 0.5
    from: 0.0
    to: 1.0

    handle: Rectangle {
        id: handleComponent
        x: control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))
        implicitWidth: 28
        implicitHeight: 28
        radius: width / 2
        color: control.pressed ? control.palette.light : control.palette.window
        border.width: control.visualFocus ? 2 : 1
        border.color: control.visualFocus ? control.palette.highlight : control.enabled ? control.palette.mid : control.palette.midlight

        Item {
            id: knobRoot
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            anchors.bottomMargin: 4 + Math.sqrt( 2 ) * knobPeak.width - roundKnob.radius
            implicitHeight: control.pressed ? parent.height * 2 : parent.height
            implicitWidth: control.pressed ? parent.height * 2 : parent.height

            Rectangle {
                id: roundKnob
                implicitHeight: parent.height
                implicitWidth: parent.width
                radius: implicitWidth / 2
                color: control.color
                antialiasing: true

                Rectangle {
                    id: knobPeak
                    implicitHeight: parent.height / 2
                    implicitWidth: parent.width / 2
                    color: control.color
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    antialiasing: true
                }

                transform: [
                    Rotation {
                        origin { x: knobRoot.width / 2; y: knobRoot.height / 2 }
                        angle: 45;
                    }
                ]
            }

            Behavior on implicitHeight {
                NumberAnimation { duration: 200}
            }

            Behavior on implicitWidth {
                NumberAnimation { duration: 200}
            }
        }
    }

    background: Item {
        id: bg

        x: control.leftPadding + (control.horizontal ? 0 : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : 0)


        implicitWidth: control.horizontal ? 200 : 8
        implicitHeight: control.horizontal ? 8 : 200
        width: control.horizontal ? control.availableWidth : implicitWidth
        height: control.horizontal ? implicitHeight : control.availableHeight

        Rectangle {
            x: handleComponent.width / 2
            width: parent.height
            height: parent.width - handleComponent.width
            border.color: "black"
            border.width: 1
            rotation: -90
            transformOrigin: Item.TopLeft
            transform: Translate { y: bg.height }
            gradient: Gradient {
                GradientStop {position: 0.000; color: Qt.rgba(1, 0, 0, 1)}
                GradientStop {position: 0.167; color: Qt.rgba(1, 1, 0, 1)}
                GradientStop {position: 0.333; color: Qt.rgba(0, 1, 0, 1)}
                GradientStop {position: 0.500; color: Qt.rgba(0, 1, 1, 1)}
                GradientStop {position: 0.667; color: Qt.rgba(0, 0, 1, 1)}
                GradientStop {position: 0.833; color: Qt.rgba(1, 0, 1, 1)}
                GradientStop {position: 1.000; color: Qt.rgba(1, 0, 0, 1)}
            }
        }
    }
}
