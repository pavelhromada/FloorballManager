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

    function openPlayerDialog( title, playerId, firstName, lastName, photo ) {
//        playersView.photosCached = false
        playerDialog.cameraActive = true
        playerDialog.title = title
        playerDialog.playerId = playerId
        playerDialog.firstName = firstName
        playerDialog.lastName = lastName
        playerDialog.photoSource = photo
        playerDialog.open()
    }

    header: PageToolBar {
        title: "Players"
        backButtonVisible: true
        pageAction: Action {
            icon.source: "../../../images/add.png"
            onTriggered: {
                openPlayerDialog( "New player", -1, "", "", "../../images/photo.png" )
            }
        }
    }

    PlayersView {
        id: playersView
        anchors.fill: parent
        photosCached: false
        editEnabled: true
        onEditPlayerTriggered: {
            openPlayerDialog( "Edit player", playerId, firstName,
                              lastName, photoUrl == "" ? "../../images/photo.png" : photoUrl )
        }
    }

    PlayerDialog {
        id: playerDialog

        onAccepted: {
            if (playerId === -1) {
                if (playersModel.addPlayer( firstName, lastName )) {

                    if (newPhotoTaken)
                        floorballManager.savePhotoPreview( -1 )

                    showToolTip( "Added new player '" + firstName + " " + lastName + "'" )
                } else {
                    showToolTip( "Error adding player '"
                                + (!firstName ? "" : firstName)
                                + " "
                                + (!lastName ? "" : lastName) + "'" )
                }
            } else {
                if (playersModel.editPlayer( playerId, firstName, lastName )) {
                    if (newPhotoTaken)
                        floorballManager.savePhotoPreview( playerId )
                } else {
                    showToolTip( "Error adding player '"
                                + (!firstName ? "" : firstName)
                                + " "
                                + (!lastName ? "" : lastName) + "'" )
                }
            }

//            playersView.photosCached = true
        }

        onRejected: {
//            playersView.photosCached = true
            forceStackViewFocus()
        }
    }


}
