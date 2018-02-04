/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

Item {
    id: secondPage

    ListView {
        id: listView
        anchors.fill: parent

        contentWidth: headerItem.width
        headerPositioning: ListView.OverlayHeader

        header: RowLayout {
            property alias dateFieldWidth: dateLabel.width
            property alias playersCountFieldWidth: playersLabel.width

            width: listView.width
            z: 2
            spacing: 0

            Label {
                id: dateLabel
                Layout.fillWidth: true
                text: "Date"
                font.bold: true
                font.pixelSize: 20
                padding: 10
                background: Rectangle { color: "silver" }
            }

            Label {
                id: playersLabel
                Layout.fillWidth: true
                text: "Players Count"
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
                width: listView.headerItem.dateFieldWidth + listView.headerItem.playersCountFieldWidth

                Row {
                    anchors.fill: parent
                    Label {
                        padding: 10
                        width: listView.headerItem.dateFieldWidth
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        text: GameDate
                        font.pixelSize: 20
                    }

                    Label {
                        padding: 10
                        width: listView.headerItem.playersCountFieldWidth
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        text: PlayersCount
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
