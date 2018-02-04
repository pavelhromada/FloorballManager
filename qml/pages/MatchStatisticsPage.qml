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
    property string gameDate

    function handleGoBack() {
        return false
    }

    header: PageToolBar {
        title: "Game statistics: " + root.gameDate
        backButtonVisible: true
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        TeamStatistics {
            model: teamAStatisticsModel
        }

        TeamStatistics {
            model: teamBStatisticsModel
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: "Team A"
        }
        TabButton {
            text: "Team B"
        }
    }
}
