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

    function handleGoBack() {
        return false
    }

    header: PageToolBar {
        title: "Statistics"
        backButtonVisible: true
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        AttendanceStatistics {}
        GamesStatistics {}
        PlayersView {}
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: "Attendance"
        }
        TabButton {
            text: "Games"
        }
        TabButton {
            text: "Players"
        }
    }
}
