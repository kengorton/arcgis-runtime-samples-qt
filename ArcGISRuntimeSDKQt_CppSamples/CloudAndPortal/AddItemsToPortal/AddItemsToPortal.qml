// [WriteFile Name=AddItemsToPortal, Category=CloudAndPortal]
// [Legal]
// Copyright 2016 Esri.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// [Legal]

import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import Esri.Samples 1.0
import Esri.ArcGISExtras 1.1
import Esri.ArcGISRuntime.Toolkit.Dialogs 2.0

AddItemsToPortalSample {
    id: rootRectangle
    clip: true

    width: 800
    height: 600

    property real scaleFactor: System.displayScaleFactor

    onPortalItemTitleChanged: portalItemModel.setProperty(0, "value", portalItemTitle);
    onPortalItemIdChanged: portalItemModel.setProperty(1, "value", portalItemId);
    onPortalItemTypeNameChanged: portalItemModel.setProperty(2, "value", portalItemTypeName);


    Flickable {
        anchors.fill: parent
        interactive: true
        boundsBehavior: Flickable.StopAtBounds
        contentHeight: parent.height * 1.5
        contentWidth: parent.width
        Column {
            anchors {
                fill: parent
                margins: 16 * scaleFactor
            }
            spacing: 16 * scaleFactor

            Rectangle {
                id: authenticationButton
                anchors.horizontalCenter: parent.horizontalCenter
                height: 64 * scaleFactor
                width: Math.min(256 * scaleFactor, parent.width)
                color: enabled ? "darkblue" : "darkgrey"
                border{
                    color: "lightgrey"
                    width: 2 * scaleFactor
                }
                radius: 8
                enabled: !portalLoaded

                Row {
                    anchors.fill: parent
                    spacing: 16 * scaleFactor

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        source: !portalLoaded ?
                                    "qrc:/Samples/CloudAndPortal/AddItemsToPortal/ic_menu_account_dark.png" :
                                    "qrc:/Samples/CloudAndPortal/AddItemsToPortal/ic_menu_checkedcircled_dark.png"
                        fillMode: Image.PreserveAspectFit
                        height: 64 * scaleFactor
                        width: height
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Authenticate Portal"
                        font.bold: true
                        color: "white"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        authenticatePortal();
                        authenticationButton.border.width = 4 * scaleFactor;
                    }
                }
            }

            Rectangle {
                id: addItemButton
                anchors.horizontalCenter: parent.horizontalCenter
                height: authenticationButton.height
                width: authenticationButton.width
                color: enabled ? "darkblue" : "darkgrey"
                border{
                    color: authenticationButton.border.color
                    width: 2 * scaleFactor
                }
                radius: authenticationButton.radius
                enabled: !portalItemLoaded && portalLoaded

                Row {
                    anchors.fill: parent
                    spacing: 16 * scaleFactor

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        source: portalItemLoaded ?
                                    "qrc:/Samples/CloudAndPortal/AddItemsToPortal/ic_menu_checkedcircled_dark.png" :
                                    "qrc:/Samples/CloudAndPortal/AddItemsToPortal/ic_menu_addencircled_dark.png"

                        fillMode: Image.PreserveAspectFit
                        height: 64 * scaleFactor
                        width: height
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Add Item"
                        font.bold: true
                        color: "white"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        addItemButton.border.width = 4 * scaleFactor
                        addItem();
                    }
                }
            }

            Rectangle {
                id: deleteItemButton
                anchors.horizontalCenter: parent.horizontalCenter
                height: authenticationButton.height
                width: authenticationButton.width
                color: enabled ? "darkblue" : "darkgrey"
                border {
                    color: authenticationButton.border.color
                    width: 2 * scaleFactor
                }
                radius: authenticationButton.radius
                enabled: portalItemLoaded && !itemDeleted

                Row {
                    anchors.fill: parent
                    spacing: 16 * scaleFactor

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        source: !itemDeleted ?
                                    "qrc:/Samples/CloudAndPortal/AddItemsToPortal/ic_menu_trash_dark.png" :
                                    "qrc:/Samples/CloudAndPortal/AddItemsToPortal/ic_menu_checkedcircled_dark.png"

                        fillMode: Image.PreserveAspectFit
                        height: 64 * scaleFactor
                        width: height
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Delete Item"
                        font.bold: true
                        color: "white"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        deleteItemButton.border.width = 2 * scaleFactor
                        deleteItem();
                    }
                }
            }

            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                }
                height: 4 * scaleFactor
                color: "lightgrey"
            }

            Rectangle {
                id: itemView
                anchors {
                    left: parent.left
                    right: parent.right
                }
                height: 128 * scaleFactor
                color: "lightsteelblue"
                border {
                    color: "darkgrey"
                    width: 4 * scaleFactor
                }
                radius: 32
                clip: true

                Text {
                    id: portalItemLabel
                    anchors{
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                        margins: 4 * scaleFactor
                    }
                    color: "white"
                    font.bold: true
                    text: "PortalItem"
                    font.underline: true
                    horizontalAlignment: Text.AlignHCenter
                }

                ListModel {
                    id: portalItemModel

                    Component.onCompleted: {
                        append({"label": "title", "value": portalItemTitle });
                        append({"label": "itemId", "value": portalItemId});
                        append({"label": "type", "value": portalItemTypeName});
                    }
                }

                ListView {
                    anchors {
                        top: portalItemLabel.bottom
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        margins: 16 * scaleFactor
                    }
                    clip: true
                    model: portalItemModel
                    delegate: Text {
                        color: "white"
                        text: label + ":\t" + value
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                    }
                }
            }

            Text {
                id: statusBar
                anchors{
                    left: parent.left
                    right: parent.right
                }
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                text: statusText
            }
        }
    }

    AuthenticationView {
        authenticationManager: authManager
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: busy
    }

    // Neatline rectangle
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border {
            width: 0.5 * scaleFactor
            color: "black"
        }
    }
}
