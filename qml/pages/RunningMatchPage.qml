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
    id: page

    property color teamAColor: "white"
    property color teamBColor: "white"

    function handleGoBack() {
        if (!finishMatchDialog.opened) {
            finishMatchDialog.saveStatisticsChecked = true
            finishMatchDialog.open()
        }

        return true
    }

    FloorballCourt {
        id: court

        anchors.fill: parent
        teamAColor: page.teamAColor
        teamBColor: page.teamBColor

        centerCircleContent: IconClickable {
            height: court.circleWidth * 0.6
            iconSource: "../../images/whistle-red.svg"
            onClicked: {
                finishMatchDialog.saveStatisticsChecked = true
                finishMatchDialog.open()
            }
        }

        leftField: Item {
            anchors.fill: parent

            GoalCounter {
                width: court.isHorizontal ? parent.width * 0.9 : parent.width * 0.6
                height: court.isHorizontal ? parent.height * 0.6 : parent.height * 0.9
                anchors.centerIn: parent
                goals: teamADrawer.goals
                onClicked: teamADrawer.open()
            }
        }

        rightField: Item {
            anchors.fill: parent

            GoalCounter {
                width: court.isHorizontal ? parent.width * 0.9 : parent.width * 0.6
                height: court.isHorizontal ? parent.height * 0.6 : parent.height * 0.9
                anchors.centerIn: parent
                goals: teamBDrawer.goals
                onClicked: teamBDrawer.open()
            }
        }
    }

    TeamDrawer {
        id: teamADrawer
        model: teamAModel
        onPlayerGoalsChanged: teamAModel.setPlayerGoals( playerId, goals )
        addPlayerAction: Action {
            text: "+"
            enabled: !remainingPlayersModel.empty
            onTriggered: {
                if (remainingPlayersModel.empty) {
                    showToolTip( "All players are playing" )
                    return
                }

                addPlayerDialog.newPlayerTeamA = true
                addPlayerDialog.open()
            }
        }
    }
    
    TeamDrawer {
        id: teamBDrawer
        model: teamBModel
        edge: Qt.RightEdge
        onPlayerGoalsChanged: teamBModel.setPlayerGoals( playerId, goals )
        addPlayerAction: Action {
            text: "+"
            enabled: !remainingPlayersModel.empty
            onTriggered: {
                if (remainingPlayersModel.empty) {
                    showToolTip( "All players are playing" )
                    return
                }

                addPlayerDialog.newPlayerTeamA = false
                addPlayerDialog.open()
            }
        }
    }

    Dialog {
        id: finishMatchDialog

        property alias saveStatisticsChecked: saveStatsCheckBox.checked

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        parent: ApplicationWindow.overlay

        modal: true
        title: "Finish the game"
        standardButtons: Dialog.Ok

        CheckBox {
            id: saveStatsCheckBox
            text: "Save game statistics"
            anchors.centerIn: parent
        }

        onAccepted: {
            if (saveStatisticsChecked) {
                floorballManager.saveMatchStatistics( teamADrawer.goals, teamBDrawer.goals )
                showToolTip( "Match statistics saved" )
            }

            goToMainMenu()
        }

        onRejected: forceStackViewFocus()

        Component.onCompleted: {
            var button = finishMatchDialog.standardButton( Dialog.Ok )
            button.text = "FINISH"
        }
    }

    Dialog {
        id: addPlayerDialog

        property bool newPlayerTeamA: false

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: Math.min( page.width, page.height ) / 3 * 2
        contentHeight: Math.min( parent.height * 0.7, remainingPlayersView.contentHeight )
        parent: Overlay.overlay
        leftPadding: 0
        rightPadding: 0

        modal: true
        title: "Add player to "+ (newPlayerTeamA ? "left" : "right") + " team"
        standardButtons: Dialog.Close

        PlayersView {
            id: remainingPlayersView
            anchors.fill: parent
            clip: true
            model: remainingPlayersModel
            defaultAction: function ( playerId, firstName, lastName ) {
                if (addPlayerDialog.newPlayerTeamA)
                    floorballManager.addPlayerToTeamA( playerId )
                else
                    floorballManager.addPlayerToTeamB( playerId )

                addPlayerDialog.close()
            }
        }
    }
}
