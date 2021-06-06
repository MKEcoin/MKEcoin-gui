// Copyright (c) 2018-2021, The MKEcoin Project
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
import QtGraphicalEffects 1.0
import MKEcoinComponents.Wallet 1.0
import MKEcoinComponents.NetworkType 1.0
import MKEcoinComponents.Clipboard 1.0
import FontAwesome 1.0

import "components" as MKEcoinComponents
import "components/effects/" as MKEcoinEffects

Rectangle {
    id: panel

    property int currentAccountIndex
    property alias currentAccountLabel: accountLabel.text
    property string balanceString: "?.??"
    property string balanceUnlockedString: "?.??"
    property string balanceFiatString: "?.??"
    property string minutesToUnlock: ""
    property bool isSyncing: false
    property alias networkStatus : networkStatus
    property alias progressBar : progressBar
    property alias daemonProgressBar : daemonProgressBar

    property int titleBarHeight: 50
    property string copyValue: ""
    Clipboard { id: clipboard }

    signal historyClicked()
    signal transferClicked()
    signal receiveClicked()
    signal advancedClicked()
    signal settingsClicked()
    signal addressBookClicked()
    signal accountClicked()

    function selectItem(pos) {
        menuColumn.previousButton.checked = false
        if(pos === "History") menuColumn.previousButton = historyButton
        else if(pos === "Transfer") menuColumn.previousButton = transferButton
        else if(pos === "Receive")  menuColumn.previousButton = receiveButton
        else if(pos === "AddressBook") menuColumn.previousButton = addressBookButton
        else if(pos === "Settings") menuColumn.previousButton = settingsButton
        else if(pos === "Advanced") menuColumn.previousButton = advancedButton
        else if(pos === "Account") menuColumn.previousButton = accountButton
        menuColumn.previousButton.checked = true
    }

    width: 300
    color: "transparent"
    anchors.bottom: parent.bottom
    anchors.top: parent.top

    MKEcoinEffects.GradientBackground {
        anchors.fill: parent
        fallBackColor: MKEcoinComponents.Style.middlePanelBackgroundColor
        initialStartColor: MKEcoinComponents.Style.leftPanelBackgroundGradientStart
        initialStopColor: MKEcoinComponents.Style.leftPanelBackgroundGradientStop
        blackColorStart: MKEcoinComponents.Style._b_leftPanelBackgroundGradientStart
        blackColorStop: MKEcoinComponents.Style._b_leftPanelBackgroundGradientStop
        whiteColorStart: MKEcoinComponents.Style._w_leftPanelBackgroundGradientStart
        whiteColorStop: MKEcoinComponents.Style._w_leftPanelBackgroundGradientStop
        posStart: 0.6
        start: Qt.point(0, 0)
        end: Qt.point(height, width)
    }

    // card with MKEcoin logo
    Column {
        visible: true
        z: 2
        id: column1
        height: 175
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: (persistentSettings.customDecorations)? 50 : 0

        Item {
            Item {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.leftMargin: 20
                height: 490
                width: 260

                Image {
                    id: card
                    visible: !isOpenGL || MKEcoinComponents.Style.blackTheme
                    width: 260
                    height: 135
                    fillMode: Image.PreserveAspectFit
                    source: MKEcoinComponents.Style.blackTheme ? "qrc:///images/card-background-black.png" : "qrc:///images/card-background-white.png"
                }

                DropShadow {
                    visible: isOpenGL && !MKEcoinComponents.Style.blackTheme
                    anchors.fill: card
                    horizontalOffset: 3
                    verticalOffset: 3
                    radius: 10.0
                    samples: 15
                    color: "#3B000000"
                    source: card
                    cached: true
                }

                MKEcoinComponents.TextPlain {
                    id: testnetLabel
                    visible: persistentSettings.nettype != NetworkType.MAINNET
                    text: (persistentSettings.nettype == NetworkType.TESTNET ? qsTr("Testnet") : qsTr("Stagenet")) + translationManager.emptyString
                    anchors.top: parent.top
                    anchors.topMargin: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 192
                    font.bold: true
                    font.pixelSize: 12
                    color: "#f33434"
                    themeTransition: false
                }

                MKEcoinComponents.TextPlain {
                    id: viewOnlyLabel
                    visible: viewOnly
                    text: qsTr("View Only") + translationManager.emptyString
                    anchors.top: parent.top
                    anchors.topMargin: 8
                    anchors.right: testnetLabel.visible ? testnetLabel.left : parent.right
                    anchors.rightMargin: 8
                    font.pixelSize: 12
                    font.bold: true
                    color: "#ff9323"
                    themeTransition: false
                }
            }

            Item {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.leftMargin: 20
                height: 490
                width: 50

                MKEcoinComponents.Label {
                    fontSize: 12
                    id: accountIndex
                    text: qsTr("Account") + translationManager.emptyString + " #" + currentAccountIndex
                    color: MKEcoinComponents.Style.blackTheme ? "white" : "black"
                    anchors.left: parent.left
                    anchors.leftMargin: 60
                    anchors.top: parent.top
                    anchors.topMargin: 23
                    themeTransition: false

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: appWindow.showPageRequest("Account")
                    }
                }

                MKEcoinComponents.Label {
                    fontSize: 16
                    id: accountLabel
                    textWidth: 170
                    color: MKEcoinComponents.Style.blackTheme ? "white" : "black"
                    anchors.left: parent.left
                    anchors.leftMargin: 60
                    anchors.top: parent.top
                    anchors.topMargin: 36
                    themeTransition: false
                    elide: Text.ElideRight

                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: appWindow.showPageRequest("Account")
                    }
                }

                MKEcoinComponents.Label {
                    fontSize: 16
                    visible: isSyncing
                    text: qsTr("Syncing...") + translationManager.emptyString
                    color: MKEcoinComponents.Style.blackTheme ? "white" : "black"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.bottom: currencyLabel.top
                    anchors.bottomMargin: 15
                    themeTransition: false
                }

                MKEcoinComponents.TextPlain {
                    id: currencyLabel
                    font.pixelSize: 16
                    text: {
                        if (persistentSettings.fiatPriceEnabled && persistentSettings.fiatPriceToggle) {
                            return appWindow.fiatApiCurrencySymbol();
                        } else {
                            return "XMR"
                        }
                    }
                    color: MKEcoinComponents.Style.blackTheme ? "white" : "black"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 100
                    themeTransition: false

                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        visible: persistentSettings.fiatPriceEnabled
                        cursorShape: Qt.PointingHandCursor
                        onClicked: persistentSettings.fiatPriceToggle = !persistentSettings.fiatPriceToggle
                    }
                }

                MKEcoinComponents.TextPlain {
                    id: balancePart1
                    themeTransition: false
                    anchors.left: parent.left
                    anchors.leftMargin: 58
                    anchors.baseline: currencyLabel.baseline
                    color: MKEcoinComponents.Style.blackTheme ? "white" : "black"
                    Binding on color {
                        when: balancePart1MouseArea.containsMouse || balancePart2MouseArea.containsMouse
                        value: MKEcoinComponents.Style.orange
                    }
                    text: {
                        if (persistentSettings.fiatPriceEnabled && persistentSettings.fiatPriceToggle) {
                            return balanceFiatString.split('.')[0] + "."
                        } else {
                            return balanceString.split('.')[0] + "."
                        }
                    }
                    font.pixelSize: {
                        var defaultSize = 29;
                        var digits = (balancePart1.text.length - 1)
                        if (digits > 2 && !(persistentSettings.fiatPriceEnabled && persistentSettings.fiatPriceToggle)) {
                            return defaultSize - 1.1 * digits
                        } else {
                            return defaultSize
                        }
                    }
                    MouseArea {
                        id: balancePart1MouseArea
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                                console.log("Copied to clipboard");
                                clipboard.setText(balancePart1.text + balancePart2.text);
                                appWindow.showStatusMessage(qsTr("Copied to clipboard"),3)
                        }
                    }
                }
                MKEcoinComponents.TextPlain {
                    id: balancePart2
                    themeTransition: false
                    anchors.left: balancePart1.right
                    anchors.leftMargin: 2
                    anchors.baseline: currencyLabel.baseline
                    color: balancePart1.color
                    text: {
                        if (persistentSettings.fiatPriceEnabled && persistentSettings.fiatPriceToggle) {
                            return balanceFiatString.split('.')[1]
                        } else {
                            return balanceString.split('.')[1]
                        }
                    }
                    font.pixelSize: 16
                    MouseArea {
                        id: balancePart2MouseArea
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: balancePart1MouseArea.clicked(mouse)
                    }
                }

                Item { //separator
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                }
            }
        }
    }

    Rectangle {
        id: menuRect
        z: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: column1.bottom
        color: "transparent"

        Flickable {
            id:flicker
            contentHeight: menuColumn.height
            anchors.top: parent.top
            anchors.bottom: progressBar.visible ? progressBar.top : networkStatus.top
            width: parent.width
            boundsBehavior: isMac ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds
            clip: true

        Column {
            id: menuColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            clip: true
            property var previousButton: transferButton

            // top border
            MKEcoinComponents.MenuButtonDivider {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- Account tab ---------------
            MKEcoinComponents.MenuButton {
                id: accountButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Account") + translationManager.emptyString
                symbol: qsTr("T") + translationManager.emptyString
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = accountButton
                    panel.accountClicked()
                }
            }

            MKEcoinComponents.MenuButtonDivider {
                visible: accountButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- Transfer tab ---------------
            MKEcoinComponents.MenuButton {
                id: transferButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Send") + translationManager.emptyString
                symbol: qsTr("S") + translationManager.emptyString
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = transferButton
                    panel.transferClicked()
                }
            }

            MKEcoinComponents.MenuButtonDivider {
                visible: transferButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- AddressBook tab ---------------

            MKEcoinComponents.MenuButton {
                id: addressBookButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Address book") + translationManager.emptyString
                symbol: qsTr("B") + translationManager.emptyString
                under: transferButton
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = addressBookButton
                    panel.addressBookClicked()
                }
            }

            MKEcoinComponents.MenuButtonDivider {
                visible: addressBookButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- Receive tab ---------------
            MKEcoinComponents.MenuButton {
                id: receiveButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Receive") + translationManager.emptyString
                symbol: qsTr("R") + translationManager.emptyString
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = receiveButton
                    panel.receiveClicked()
                }
            }

            MKEcoinComponents.MenuButtonDivider {
                visible: receiveButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- History tab ---------------

            MKEcoinComponents.MenuButton {
                id: historyButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Transactions") + translationManager.emptyString
                symbol: qsTr("H") + translationManager.emptyString
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = historyButton
                    panel.historyClicked()
                }
            }

            MKEcoinComponents.MenuButtonDivider {
                visible: historyButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- Advanced tab ---------------
            MKEcoinComponents.MenuButton {
                id: advancedButton
                visible: appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Advanced") + translationManager.emptyString
                symbol: qsTr("D") + translationManager.emptyString
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = advancedButton
                    panel.advancedClicked()
                }
            }

            MKEcoinComponents.MenuButtonDivider {
                visible: advancedButton.present && appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- Settings tab ---------------
            MKEcoinComponents.MenuButton {
                id: settingsButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Settings") + translationManager.emptyString
                symbol: qsTr("E") + translationManager.emptyString
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = settingsButton
                    panel.settingsClicked()
                }
            }

            MKEcoinComponents.MenuButtonDivider {
                visible: settingsButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

        } // Column

        } // Flickable

        Rectangle {
            id: separator
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.bottom: progressBar.visible ? progressBar.top : networkStatus.top
            height: 10
            color: "transparent"
        }

        MKEcoinComponents.ProgressBar {
            id: progressBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: daemonProgressBar.top
            height: 48
            syncType: qsTr("Wallet") + translationManager.emptyString
            visible: !appWindow.disconnected
        }

        MKEcoinComponents.ProgressBar {
            id: daemonProgressBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: networkStatus.top
            syncType: qsTr("Daemon") + translationManager.emptyString
            visible: !appWindow.disconnected
            height: 62
        }
        
        MKEcoinComponents.NetworkStatusItem {
            id: networkStatus
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 5
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            connected: Wallet.ConnectionStatus_Disconnected
            height: 48
        }
    }
}
