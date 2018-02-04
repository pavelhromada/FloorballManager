/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Material.impl 2.3

SpinBox {
    id: control
    editable: false
    baselineOffset: 0
    
    up.indicator: Item {
        x: control.mirrored ? 0 : parent.width - width
        implicitWidth: 48
        implicitHeight: 48
        height: parent.height
        width: height

        Rectangle {
            anchors.centerIn: parent
            width: parent.width - 12
            height: parent.height - 12
            radius: 2
            color: enabled ? control.Material.highlightedButtonColor
                           : "lightGrey"

            layer.enabled: control.enabled && control.value != control.to
            layer.effect: ElevationEffect {
                elevation: control.up.pressed ? 8 : 2
            }

            Rectangle {
                x: (parent.width - width) / 2
                y: (parent.height - height) / 2
                width: Math.min(parent.width / 3, parent.height / 3)
                height: 2
                color: !control.enabled
                       ? "grey"
                       : "white"
            }
            Rectangle {
                x: (parent.width - width) / 2
                y: (parent.height - height) / 2
                width: 2
                height: Math.min(parent.width / 3, parent.height / 3)
                color: !control.enabled
                       ? "grey"
                       : "white"
            }
        }
    }
    
    down.indicator: Item {
        x: control.mirrored ? parent.width - width : 0
        implicitWidth: 48
        implicitHeight: 48
        height: parent.height
        width: height

        Rectangle {
            anchors.centerIn: parent
            width: parent.width - 12
            height: parent.height - 12
            radius: 2
            color: enabled ? control.Material.highlightedButtonColor
                           : "lightGrey"

            layer.enabled: control.enabled && control.value != control.from
            layer.effect: ElevationEffect {
                elevation: control.down.pressed ? 8 : 2
            }

            Rectangle {
                x: (parent.width - width) / 2
                y: (parent.height - height) / 2
                width: parent.width / 3
                height: 2
                color: !control.enabled
                       ? "grey"
                       : "white"
            }
        }
    }
    
    background: Item {
        implicitWidth: 192
        implicitHeight: 48
    }
}
