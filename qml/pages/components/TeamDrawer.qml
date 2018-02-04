/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

Drawer {
    id: root

    readonly property alias goals: goalsCounter.value
    property alias model: playersList.model
    property Action addPlayerAction

    signal playerGoalsChanged( int playerId, int goals )

    width: parent.width > parent.height ? 0.48 * parent.width : 0.8 * parent.width
    height: parent.height
    
    GoalsSpinBox {
        id: goalsCounter
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 22
        }
        height: 60
        width: 200
        font {
            bold: true
            pixelSize: 32
        }
    }

    ListView {
        id: playersList

        property int delegateHeight: 70
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: goalsCounter.bottom
            topMargin: 22
        }
        clip: true
        cacheBuffer: delegateHeight * count
        
        delegate: ItemDelegate {
            width: parent.width
            height: playersList.delegateHeight

            RowLayout {
                spacing: /*implicitWidth > parent.width ? 6 : */16
                layoutDirection: root.edge === Qt.LeftEdge ? Qt.RightToLeft : Qt.LeftToRight
                anchors {
                    fill: parent
                    margins: 10
                    leftMargin: /*implicitWidth > parent.width ? 6 : */16
                    rightMargin: /*implicitWidth > parent.width ? 6 : */16

                }
                
                RoundImage {
                    id: photo
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: parent.height
                    fillMode: Image.PreserveAspectFit
                    source: PhotoUrl ? PhotoUrl : "../../../images/photo.png"
                }
                
                Label {
                    Layout.fillWidth: true
                    text: FirstName + " " + LastName
                    horizontalAlignment: root.edge === Qt.LeftEdge ? Text.AlignRight : Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                }
                
                GoalsSpinBox {
                    Layout.preferredWidth: up.indicator.width * 2.5
                    onValueChanged: playerGoalsChanged( Id, value )
                }
            }
        }
        
        ScrollIndicator.vertical: ScrollIndicator {}
    }

    RoundButton {
        action: addPlayerAction
        visible: addPlayerAction != undefined && addPlayerAction.enabled
        highlighted: true
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: 16
        }
    }
}
