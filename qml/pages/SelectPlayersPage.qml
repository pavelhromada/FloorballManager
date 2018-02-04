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
            onTriggered: {
                if (floorballManager.selectedPlayersCount() < 2)
                    showToolTip( "Not enough players selected!" )
                else if (floorballManager.selectedPlayersCount() < 6)
                    warningDialog.open()
                else {
                    floorballManager.shuffleTeams()
                    showPage( "TeamsPicksPage" )
                }
            }
        }
    }

    ListView {
        anchors.fill: parent
        model: playersModel
        cacheBuffer: 100 * count // TODO this is temporary workaround
        delegate: CheckDelegate {
            id: delegateControl

            width: parent.width
            height: 70
            text: FirstName + " " + LastName

            onCheckedChanged: {
                if (checked)
                    floorballManager.selectPlayer( Id )
                else
                    floorballManager.deselectPlayer( Id )
            }

            contentItem: RowLayout {
                spacing: 20
                anchors {
                    fill: parent
                    margins: 10
                }

                RoundImage {
                    id: photo
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: parent.height + 20
                    fillMode: Image.PreserveAspectFit
                    source: PhotoUrl ? PhotoUrl : "../../../images/photo.png"
                }

                Text {
                    Layout.fillWidth: true
                    leftPadding: !delegateControl.mirrored
                                 ? 0
                                 : delegateControl.indicator.width + delegateControl.spacing
                    rightPadding: delegateControl.mirrored
                                  ? 0
                                  : delegateControl.indicator.width + delegateControl.spacing

                    text: delegateControl.text
                    font: delegateControl.font
                    color: delegateControl.enabled ? delegateControl.Material.foreground
                                                   : delegateControl.Material.hintTextColor
                    elide: Text.ElideRight
                    visible: delegateControl.text
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        ScrollIndicator.vertical: ScrollIndicator {}
    }

    Dialog {
        id: warningDialog

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        parent: ApplicationWindow.overlay

        modal: true
        title: "Not enough players selected"
        standardButtons: Dialog.Yes | Dialog.No

        Label {
            anchors.fill: parent
            text: "Continue anyway?"
        }

        onAccepted: {
            floorballManager.shuffleTeams()
            showPage( "TeamsPicksPage" )
            forceStackViewFocus()
        }

        onRejected: forceStackViewFocus()
    }
}
