/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3
import "pages"
import "pages/components"

ApplicationWindow {
    id: appWindow

    visible: true
    width: 1280
    height: 800
    title: qsTr("Floorball Manager")

    function goToMainMenu() {
        stackView.pop( null )
        forceStackViewFocus()
    }

    function showPage( page, properties ) {
        if (!properties)
            stackView.push( "qrc:/qml/pages/" + page + ".qml" )
        else
            stackView.push( "qrc:/qml/pages/" + page + ".qml", properties )
    }

    function goBack() {
        if (stackView.depth > 1)
            stackView.pop()
    }

    function forceStackViewFocus() {
        stackView.forceActiveFocus()
    }

    function showToolTip( text ) {
        toolTip.show( text )
    }

    StackView {
        id: stackView

        anchors.fill: parent
        focus: true
        initialItem: MainMenuPage {}

        Keys.onBackPressed: {
            event.accepted = true

            // ask current view if we can go back or it has some special handling for go back
            if (stackView.currentItem.handleGoBack())
                return

            if (stackView.depth === 1) {
                quitAppDialog.open()
                return
            }

            goBack()
        }

        Dialog {
            id: quitAppDialog

            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            parent: ApplicationWindow.overlay

            modal: true
            title: "Exit application"
            standardButtons: Dialog.Yes | Dialog.No

            Label {
                anchors.fill: parent
                text: "Do you really want to exit application?"
            }

            onAccepted: Qt.quit()
            onRejected: forceStackViewFocus()
        }
    }

    GlobalToolTip {
        id: toolTip
    }
}
