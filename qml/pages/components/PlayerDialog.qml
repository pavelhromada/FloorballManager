/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

Dialog {
    id: playerDialog

    property alias firstName: firstNameField.text
    property alias lastName: lastNameField.text
    property int playerId: -1
    property alias photoSource: photo.source
    property bool newPhotoTaken: false
    property alias cameraActive: cameraDialog.cameraActive

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    parent: ApplicationWindow.overlay
    width: 340
    focus: true
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel
    enabled: !cameraDialog.opened
    
    onAboutToShow: newPhotoTaken = false
    onAboutToHide: cameraDialog.cameraActive = false

    ColumnLayout {
        spacing: 20
        anchors.fill: parent
        
        RoundImage {
            id: photo
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 80
            Layout.preferredWidth: 80

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (cameraDialog.cameraAvailable)
                        cameraDialog.open()
                    else
                        showToolTip( "Camera not available" )
                }
            }
        }

        TextField {
            id: firstNameField
            focus: true
            placeholderText: "First name"
            Layout.fillWidth: true
        }
        
        TextField {
            id: lastNameField
            placeholderText: "Last name"
            Layout.fillWidth: true
        }
    }

    CameraDialog {
        id: cameraDialog
        onPhotoTaken: {
            if (!floorballManager.processPhotoPreview( urlSource )) {
                showToolTip( "Cannot process photo" )
                return
            }

            playerDialog.newPhotoTaken = true
            photo.source = "image://photo/photoPreview"
        }
    }
}
