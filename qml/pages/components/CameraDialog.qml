/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtMultimedia 5.8

Dialog {
    id: cameraDialog

    width: Math.min( parent.width, parent.height ) * 0.85
    height: width
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    parent: ApplicationWindow.overlay
    modal: true
    title: "Press to take a photo"
    standardButtons: Dialog.Discard | Dialog.Apply
    leftPadding: 4
    rightPadding: 4

    signal photoTaken( string urlSource )

    function resetPreview() {
        cameraDialog.applyButton.enabled = false
        photoPreview.visible = false
    }

    property var discardButton
    property var applyButton
    property bool cameraAvailable: camera.availability === Camera.Available
    property string photoUrl
    property bool cameraActive: false

    Connections {
        id: discardButtonConnection
        target: null
        onClicked: {
            if (cameraDialog.applyButton.enabled === true)
                cameraDialog.resetPreview()
            else
                cameraDialog.close()
        }
    }

    Connections {
        id: applyButtonConnection
        target: null
        onClicked: {
            cameraDialog.photoUrl = camera.__actualPreview
            cameraDialog.photoTaken( camera.__actualPreview )
            cameraDialog.close()
        }
    }

    Component.onCompleted: {
        camera.stop()
        discardButton = cameraDialog.standardButton( Dialog.Discard )
        applyButton = cameraDialog.standardButton( Dialog.Apply )

        discardButtonConnection.enabled = true
        discardButtonConnection.target = discardButton
        applyButtonConnection.enabled = true
        applyButtonConnection.target = applyButton
        applyButton.text = "\u2713"//"SAVE"
        discardButton.text = "\u2717"//"DISCARD"
        applyButton.enabled = false
    }

    onAboutToHide: camera.stop()
    onAboutToShow: {
        resetPreview()
        if (camera.__resolutionPicked === false) {
            var resList = camera.supportedViewfinderResolutions()
            var res
            for (var i = 0; i < resList.length; i++) {
                if (resList[i].width <= 800)
                    if (res == undefined || res.width < resList[i].width)
                        res = resList[i]
            }

            if (res) {
                camera.viewfinder.resolution.width = res.width
                camera.viewfinder.resolution.height = res.height
                camera.__resolutionPicked = true
            }
        }

        camera.start()
    }

    //shows live preview from camera
    VideoOutput {
        id: videoOutput
        source: camera
        anchors.fill: parent
        focus : visible

        //shows captured image
        Image {
            id: photoPreview
            anchors.fill: parent
            visible: false
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            anchors.centerIn: parent
            width: Math.min( parent.width, parent.height )
            height: width
            radius: width / 2
            color: "transparent"
            antialiasing: true
            visible: true
            border {
                width: 2
                color: "#77ffffff"
            }
        }
    }

    Rectangle {
        id: warningRect

        anchors.fill: videoOutput
        visible: (cameraDialog.parent.width < cameraDialog.parent.height) && !photoPreview.visible

        Label {
            anchors.centerIn: parent
            text: "Rotate your device to landscape mode"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Camera {
        id: camera

        property bool __resolutionPicked: false
        property string __actualPreview: ""

        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
        captureMode: Camera.CaptureStillImage
        flash.mode: Camera.FlashAuto
        cameraState: cameraDialog.cameraActive ? Camera.ActiveState : Camera.UnloadedState // TODO
        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        imageCapture {
            onImageCaptured: {
                camera.__actualPreview = preview
                photoPreview.source = preview
                photoPreview.visible = true
                cameraDialog.applyButton.enabled = true
            }
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            if (cameraDialog.applyButton.enabled === false && videoOutput.visible)
                camera.imageCapture.capture();
        }

        onPressAndHold: {
            if (cameraDialog.applyButton.enabled === false && videoOutput.visible)
                camera.searchAndLock()
        }
    }
}
