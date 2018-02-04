/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7

Rectangle {
    id: root
    
    property bool positionLeft: false
    property int lineWidth: 4
    property color lineColor: "white"
    
    implicitHeight: 220
    implicitWidth: 160
    
    color: "transparent"
    border {
        color: root.lineColor
        width: root.lineWidth
    }
    
    Rectangle {
        readonly property bool _horizontal: parent.height > parent.width
        readonly property int _offset: root.positionLeft ? Math.min( width, height ) * 0.3
                                                          : -(Math.min( width, height ) * 0.3)
        
        border {
            color: root.lineColor
            width: root.lineWidth
        }
        color: "transparent"
        height: _horizontal ? parent.height * 0.5 : parent.height * 0.4
        width: _horizontal ? parent.width * 0.4 : parent.width * 0.5
        anchors {
            centerIn: parent
            verticalCenterOffset: _horizontal ? 0 : _offset
            horizontalCenterOffset: _horizontal ? -_offset : 0
        }
    }
}
