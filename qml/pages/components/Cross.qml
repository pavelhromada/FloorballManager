/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7

Item {
    id: cross
    
    property int side: 10
    property int thickness: 8
    property color color: "white"

    height: side
    width: side
    
    Rectangle {
        anchors.centerIn: parent
        width: cross.thickness
        height: cross.side
        color: cross.color
    }
    
    Rectangle {
        anchors.centerIn: parent
        width: cross.side
        height: cross.thickness
        color: cross.color
    }
}
