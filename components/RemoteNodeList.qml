// Copyright (c) 2021, The mkecoin Project
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import QtQuick 2.9
import QtQuick.Layouts 1.1

import FontAwesome 1.0

import "." as mkecoinComponents
import "effects/" as mkecoinEffects

ColumnLayout {
    id: remoteNodeList
    spacing: 20

    mkecoinComponents.CheckBox {
        border: false
        checkedIcon: FontAwesome.minusCircle
        uncheckedIcon: FontAwesome.plusCircle
        fontAwesomeIcons: true
        fontSize: 16
        iconOnTheLeft: true
        text: qsTr("Add remote node") + translationManager.emptyString
        toggleOnClick: false
        onClicked: remoteNodeDialog.add(remoteNodesModel.append)
    }

    ColumnLayout {
        spacing: 0

        Repeater {
            model: remoteNodesModel

            Rectangle {
                height: 30
                Layout.fillWidth: true
                color: itemMouseArea.containsMouse || index === remoteNodesModel.selected ? mkecoinComponents.Style.titleBarButtonHoverColor : "transparent"

                Rectangle {
                    color: mkecoinComponents.Style.appWindowBorderColor
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: parent.top
                    height: 1
                    visible: index > 0

                    mkecoinEffects.ColorTransition {
                        targetObj: parent
                        blackColor: mkecoinComponents.Style._b_appWindowBorderColor
                        whiteColor: mkecoinComponents.Style._w_appWindowBorderColor
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.rightMargin: 80
                    color: "transparent"

                    mkecoinComponents.TextPlain {
                        color: index === remoteNodesModel.selected ? mkecoinComponents.Style.defaultFontColor : mkecoinComponents.Style.dimmedFontColor
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        font.pixelSize: 16
                        text: address
                        themeTransition: false
                    }

                    MouseArea {
                        id: itemMouseArea
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: remoteNodesModel.applyRemoteNode(index)
                    }
                }

                RowLayout {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 6
                    height: 30
                    spacing: 10

                    mkecoinComponents.InlineButton {
                        buttonColor: "transparent"
                        fontFamily: FontAwesome.fontFamily
                        fontPixelSize: 18
                        text: FontAwesome.edit
                        tooltip: qsTr("Edit remote node") + translationManager.emptyString
                        tooltipLeft: true
                        onClicked: remoteNodeDialog.edit(remoteNodesModel.get(index), function (remoteNode) {
                            remoteNodesModel.set(index, remoteNode)
                        })
                    }

                    mkecoinComponents.InlineButton {
                        buttonColor: "transparent"
                        fontFamily: FontAwesome.fontFamily
                        text: FontAwesome.times
                        visible: remoteNodesModel.count > 1
                        tooltip: qsTr("Remove remote node") + translationManager.emptyString
                        tooltipLeft: true
                        onClicked: remoteNodesModel.removeSelectNextIfNeeded(index)
                    }
                }
            }
        }
    }
}
