/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

ListView {
    id: listView

    property int __heldPlayerId: -1
    readonly property int delegateWidth: orientation == ListView.Horizontal
                                         ? parent.width * 0.2
                                         : parent.width
    readonly property int delegateHeight: orientation == ListView.Horizontal
                                          ? parent.height
                                          : parent.height * 0.2

    property bool playerHeld: false
    property int delegateLayoutDirection: Qt.LeftToRight

    orientation: parent.width > parent.height ? ListView.Horizontal : ListView.Vertical

    delegate: Item {
        id: deleg
        width: delegateWidth
        height: delegateHeight

        Item {
            id: dragRect
            width: listView.orientation == ListView.Horizontal ? deleg.width : deleg.width * 0.7
            height: listView.orientation == ListView.Horizontal ? deleg.height * 0.65 : deleg.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Drag.active: mouseArea.held
            Drag.hotSpot.x: dragRect.width / 2
            Drag.hotSpot.y: dragRect.height / 2
            Drag.source: listView

            Rectangle {
                anchors.fill: parent
                color: "#40ffffff"
                radius: height * 0.05
                opacity: mouseArea.held ? 1.0 : 0.0
                border.color: Qt.darker( color )

                Behavior on opacity { NumberAnimation { duration: 100 } }
            }

            GridLayout {
                anchors {
                    fill: parent
                    margins: 8
                }
                columns: listView.orientation == ListView.Horizontal ? 1 : 2
                layoutDirection: delegateLayoutDirection

                RoundImage {
                    Layout.preferredHeight: Math.min( parent.height, parent.width ) * 0.85
                    Layout.preferredWidth: Math.min( parent.height, parent.width ) * 0.85
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    fillMode: Image.PreserveAspectFit
                    source: PhotoUrl ? PhotoUrl : "../../../images/photo.png"
                }

                Label {
                    Layout.fillWidth: true
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: FirstName + "<br>" + LastName
                }
            }

            MouseArea {
                id: mouseArea

                property bool held: false

                anchors.fill: parent
                drag.target: held ? dragRect : undefined

                onPressAndHold: held = true
                onReleased: held = false
                onHeldChanged: {
                    if (held) {
                        listView.playerHeld = true
                        __heldPlayerId = Id
                    } else {
                        listView.playerHeld = false
                        dragRect.Drag.drop()
                    }
                }
            }

            states: [
                State {
                    when: mouseArea.held

                    ParentChange {
                        target: dragRect
                        parent: listView.parent
                    }

                    AnchorChanges {
                        target: dragRect
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: undefined
                    }
                }
            ]
        }
    }
}
