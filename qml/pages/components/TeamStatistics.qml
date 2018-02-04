/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

Item {
    property alias model: listView.model
    ListView {
        id: listView
        anchors.fill: parent

        contentWidth: headerItem.width
        headerPositioning: ListView.OverlayHeader

        header: RowLayout {
            property alias goalsFieldWidth: goalsLabel.width
            property alias playerFieldWidth: playerLabel.width

            width: listView.width
            z: 2
            spacing: 0

            Label {
                id: playerLabel
                Layout.fillWidth: true
                text: "Player"
                font.bold: true
                font.pixelSize: 20
                padding: 10
                background: Rectangle { color: "silver" }
            }

            Label {
                id: goalsLabel
                Layout.fillWidth: true
                text: "Goals"
                font.bold: true
                font.pixelSize: 20
                padding: 10
                background: Rectangle { color: "silver" }
            }
        }

        model: attendanceModel
        delegate: Column {
            id: delegate

            ItemDelegate {
                width: listView.headerItem.goalsFieldWidth + listView.headerItem.playerFieldWidth

                Row {
                    anchors.fill: parent
                    Label {
                        padding: 10
                        width: listView.headerItem.playerFieldWidth
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        text: FirstName + " " + LastName
                        font.pixelSize: 20
                    }

                    Label {
                        padding: 10
                        width: listView.headerItem.goalsFieldWidth
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        text: Goals
                        font.pixelSize: 20
                    }
                }
            }

            Rectangle {
                color: "silver"
                width: parent.width
                height: 1
            }
        }

        ScrollIndicator.vertical: ScrollIndicator { }
    }
}
