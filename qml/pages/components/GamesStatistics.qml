/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

Item {
    id: root

    ListView {
        id: listView
        anchors.fill: parent

        contentWidth: headerItem.width
        headerPositioning: ListView.OverlayHeader

        header: RowLayout {
            property alias dateFieldWidth: dateLabel.width
            property alias scoreFieldWidth: scoreLabel.width

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
                id: scoreLabel
                Layout.fillWidth: true
                text: "Score"
                font.bold: true
                font.pixelSize: 20
                padding: 10
                background: Rectangle { color: "silver" }
            }
        }

        model: gamesModel
        delegate: Column {
            id: delegate

            ItemDelegate {
                width: listView.headerItem.dateFieldWidth + listView.headerItem.scoreFieldWidth

                onClicked: {
                    teamAStatisticsModel.loadMatch( Id )
                    teamBStatisticsModel.loadMatch( Id )
                    showPage( "MatchStatisticsPage", { "gameDate": GameDate })
                }

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
                        width: listView.headerItem.scoreFieldWidth
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        text: GoalsTeamA + " : " + GoalsTeamB
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
