/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3
import "components"

Page {
    function handleGoBack() {
        return false
    }

    property string playerName

    header: PageToolBar {
        title: playerName + " Statistics"
        backButtonVisible: true
    }

    ListView {
        id: listView
        anchors.fill: parent

        contentWidth: headerItem.width
        headerPositioning: ListView.OverlayHeader

        header: RowLayout {
            property alias dateFieldWidth: dateLabel.width
            property alias goalsFieldWidth: goalsLabel.width

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
                id: goalsLabel
                Layout.fillWidth: true
                text: "Goals Scored"
                font.bold: true
                font.pixelSize: 20
                padding: 10
                background: Rectangle { color: "silver" }
            }
        }

        model: playerStatisticsModel
        delegate: Column {
            id: delegate

            ItemDelegate {
                width: listView.headerItem.dateFieldWidth + listView.headerItem.goalsFieldWidth

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
