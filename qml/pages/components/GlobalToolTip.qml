/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1

Item {
    id: toolTip
    
    property int timeout: 2500
    
    function show( text, timeout ) {
        if (!timeout || timeout <= 0)
            ToolTip.show( text )
        else
            ToolTip.show( text, timeout )
    }
    
    anchors {
        horizontalCenter: parent.horizontalCenter
        bottom: parent.bottom
        bottomMargin: 20
    }
    
    ToolTip.text: ""
    ToolTip.timeout: timeout
}
