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

    header: PageToolBar {
        title: "Select players for game"
        backButtonVisible: true
        pageAction: Action {
            icon.source: "../../../images/next.png"
            onTriggered: showPage( "RunningMatchPage",
                                  {
                                      "teamAColor": court.teamAColor,
                                      "teamBColor": court.teamBColor
                                  })
        }
    }

    FloorballCourt {
        id: court
        anchors.fill: parent
        leftFieldHigherZ: leftRoaster.playerHeld

        centerCircleContent: IconClickable {
            height: court.circleWidth * 0.6
            iconSource: "../../images/dice-3D.png"
            onClicked: floorballManager.shuffleTeams()
        }

        fullLeftField: DropArea {
            anchors.fill: parent
            onDropped: {
                if (drop.source != leftRoaster && drop.source.hasOwnProperty( "__heldPlayerId" ))
                    if (!floorballManager.movePlayerToTeamA( drop.source.__heldPlayerId ))
                        showToolTip( "Oh man. This is not possible." )
            }
        }

        leftField: TeamRoster {
            id: leftRoaster
            anchors.centerIn: parent
            width: orientation == ListView.Horizontal
                   ? Math.min( delegateWidth * count, parent.width )
                   : parent.width
            height: orientation == ListView.Horizontal
                    ? parent.height
                    : Math.min( delegateHeight * count, parent.height )
            model: teamAModel
            delegateLayoutDirection: Qt.RightToLeft
        }

        fullRightField: DropArea {
            anchors.fill: parent
            onDropped: {
                if (drop.source != rightRoaster && drop.source.hasOwnProperty( "__heldPlayerId" ))
                    if (!floorballManager.movePlayerToTeamB( drop.source.__heldPlayerId ))
                        showToolTip( "Oh man. This is not possible." )
            }
        }

        rightField: TeamRoster {
            id: rightRoaster
            anchors.centerIn: parent
            width: orientation == ListView.Horizontal
                   ? Math.min( delegateWidth * count, parent.width )
                   : parent.width
            height: orientation == ListView.Horizontal
                    ? parent.height
                    : Math.min( delegateHeight * count, parent.height )
            model: teamBModel
        }
    }
}
