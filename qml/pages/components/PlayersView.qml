/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

ListView {
    id: root

    model: playersModel

    signal editPlayerTriggered( int playerId, string firstName, string lastName, url photoUrl )

    property bool editEnabled: false
    property bool photosCached: true
    property var defaultAction: function ( playerId, firstName, lastName ) {
        showPage( "PlayerStatisticsPage", { "playerName": firstName + " " + lastName })
    }
    
    delegate: ItemDelegate {
        width: parent.width
        height: 70

        onClicked: {
            playerStatisticsModel.loadPlayer( Id )
            defaultAction( Id, FirstName, LastName )
        }

        RowLayout {
            spacing: 32
            anchors {
                fill: parent
                margins: 8
            }
            
            RoundImage {
                id: photo
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.height + 20
                fillMode: Image.PreserveAspectFit
                source: PhotoUrl ? PhotoUrl : "../../../images/photo.png"
                cached: root.photosCached
            }
            
            Label {
                Layout.fillWidth: true
                text: FirstName + " " + LastName
            }

            ToolButton {
                visible: root.editEnabled
                Layout.fillHeight: true
                icon {
                    color: "grey"
                    source: "../../../images/edit.svg"
                }
                onClicked: root.editPlayerTriggered( Id, FirstName, LastName, PhotoUrl ? PhotoUrl : "" )
            }
        }
    }
    
    ScrollIndicator.vertical: ScrollIndicator {}
}
