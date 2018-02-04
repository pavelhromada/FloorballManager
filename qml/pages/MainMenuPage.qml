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
    id: root

    property bool isHorizontal: width > height
    property int buttonWidth: Math.max( root.width, root.height ) * 0.26
    property int buttonHeight: isHorizontal ? Math.min( root.width, root.height ) * 0.18
                                            : Math.min( root.width, root.height ) * 0.14
    property int buttonMarginBaseOffet: isHorizontal ? Math.min( root.width, root.height ) * 0.1
                                                     : Math.min( root.width, root.height ) * 0.15

    function handleGoBack() {
        return false
    }

    StackView.onActivating: {
        teamAModel.resetTeam()
        teamBModel.resetTeam()
        floorballManager.resetSelectedPlayers()
    }

    header: PageToolBar {
        title: "Floorball Manager"
        backButtonVisible: false
    }

    Image {
        id: backgroundImage

        source: "../../images/player-bg.svg"
        fillMode: Image.PreserveAspectFit
        height: Math.min( root.width, root.height ) * 0.65
        sourceSize {
            width: Math.min( root.width, root.height ) * 0.65
            height: Math.min( root.width, root.height ) * 0.65
        }

        anchors {
            right: parent.right
            bottom: parent.bottom
            margins:  Math.min( root.width, root.height ) * 0.08
        }
    }

    ColumnLayout {
        id: layout
        spacing: isHorizontal ? Math.min( root.width, root.height ) * 0.04
                              : Math.min( root.width, root.height ) * 0.02
        anchors {
            margins: 32
            left: parent.left
            right: isHorizontal ? backgroundImage.left : parent.right
            top: parent.top
            bottom: isHorizontal ? parent.bottom : backgroundImage.top
        }

        MenuButton {
            id: newGameButton

            Layout.fillWidth: true
            Layout.preferredHeight: buttonHeight
            Layout.fillHeight: true
            Layout.maximumHeight: (layout.height - 2 * layout.spacing - 2 * layout.margins) / 3
            title: "New Game"
            iconSource: "../../images/floorball.png"
            onClicked: showPage( "SelectPlayersPage" )
        }

        MenuButton {
            id: playersButton

            Layout.fillWidth: true
            Layout.preferredHeight: buttonHeight
            Layout.fillHeight: true
            Layout.maximumHeight: (layout.height - 2 * layout.spacing - 2 * layout.margins) / 3
            title: "Players"
            iconSource: "../../images/players.svg"
            onClicked: showPage( "PlayersPage" )
        }

        MenuButton {
            id: statisticsButton

            Layout.fillWidth: true
            Layout.preferredHeight: buttonHeight
            Layout.fillHeight: true
            Layout.maximumHeight: (layout.height - 2 * layout.spacing - 2 * layout.margins) / 3
            title: "Statistics"
            iconSource: "../../images/stats.svg"
            onClicked: showPage( "StatisticsPage" )
        }
    }
}
