// Copyright (c) 2014-2018, The MKEcoin Project
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
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import FontAwesome 1.0

import "../components" as MKEcoinComponents
import "../components/effects/" as MKEcoinEffects

import MKEcoinComponents.Clipboard 1.0
import MKEcoinComponents.Wallet 1.0
import MKEcoinComponents.WalletManager 1.0
import MKEcoinComponents.TransactionHistory 1.0
import MKEcoinComponents.TransactionHistoryModel 1.0
import MKEcoinComponents.Subaddress 1.0
import MKEcoinComponents.SubaddressModel 1.0
import "../js/TxUtils.js" as TxUtils

Rectangle {
    id: pageReceive
    color: "transparent"
    property var model
    property alias receiveHeight: mainLayout.height

    function renameSubaddressLabel(_index){
        inputDialog.labelText = qsTr("Set the label of the selected address:") + translationManager.emptyString;
        inputDialog.onAcceptedCallback = function() {
            appWindow.currentWallet.subaddress.setLabel(appWindow.currentWallet.currentSubaddressAccount, _index, inputDialog.inputText);
        }
        inputDialog.onRejectedCallback = null;
        inputDialog.open(appWindow.currentWallet.getSubaddressLabel(appWindow.currentWallet.currentSubaddressAccount, _index))
    }

    Clipboard { id: clipboard }

    /* main layout */
    ColumnLayout {
        id: mainLayout
        anchors.margins: 20
        anchors.topMargin: 40

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right

        spacing: 15

        ColumnLayout {
            id: selectedAddressDetailsColumn
            Layout.alignment: Qt.AlignHCenter
            spacing: 0
            property int qrSize: 220

<<<<<<< HEAD
            MKEcoinComponents.LabelSubheader {
=======
            Rectangle {
                id: qrContainer
                color: MoneroComponents.Style.blackTheme ? "white" : "transparent"
>>>>>>> b6682330a6f87051c523c05b9b653eb494760003
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: parent.qrSize
                Layout.preferredHeight: width
                radius: 4

                Image {
                    id: qrCode
                    anchors.fill: parent
                    anchors.margins: 1
                    smooth: false
                    fillMode: Image.PreserveAspectFit
                    source: "image://qrcode/" + TxUtils.makeQRCodeString(appWindow.current_address)

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: {
                            if (mouse.button == Qt.LeftButton){
                                selectedAddressDetailsColumn.qrSize = selectedAddressDetailsColumn.qrSize == 220 ? 300 : 220;
                            } else if (mouse.button == Qt.RightButton){
                                qrMenu.x = this.mouseX;
                                qrMenu.y = this.mouseY;
                                qrMenu.open()
                            }
                        }
                    }
                }

                Menu {
                    id: qrMenu
                    title: "QrCode"

                    MenuItem {
                        text: qsTr("Save as Image") + translationManager.emptyString;
                        onTriggered: qrFileDialog.open()
                    }
                }
            }

            MoneroComponents.TextPlain {
                id: selectedaddressIndex
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 220
                Layout.maximumWidth: 220
                Layout.topMargin: 15
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Address #") + subaddressListView.currentIndex + translationManager.emptyString
                wrapMode: Text.WordWrap
                font.family: MoneroComponents.Style.fontRegular.name
                font.pixelSize: 17
                textFormat: Text.RichText
                color: MoneroComponents.Style.defaultFontColor
                themeTransition: false
            }

            MoneroComponents.TextPlain {
                id: selectedAddressDrescription
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 220
                Layout.maximumWidth: 220
                Layout.topMargin: 10
                horizontalAlignment: Text.AlignHCenter
                text: "(" + qsTr("no label") + ")" + translationManager.emptyString
                wrapMode: Text.WordWrap
                font.family: MoneroComponents.Style.fontRegular.name
                font.pixelSize: 17
                textFormat: Text.RichText
                color: selectedAddressDrescriptionMouseArea.containsMouse ? MoneroComponents.Style.orange : MoneroComponents.Style.dimmedFontColor
                themeTransition: false
                tooltip: subaddressListView.currentIndex > 0 ? qsTr("Edit address label") : "" + translationManager.emptyString
                MouseArea {
                    id: selectedAddressDrescriptionMouseArea
                    visible: subaddressListView.currentIndex > 0
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onEntered: parent.tooltip ? parent.tooltipPopup.open() : ""
                    onExited: parent.tooltip ? parent.tooltipPopup.close() : ""
                    onClicked: {
                        renameSubaddressLabel(appWindow.current_subaddress_table_index);
                    }
                }
            }

            MoneroComponents.TextPlain {
                id: selectedAddress
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: 300
                Layout.topMargin: 11
                text: appWindow.current_address ? appWindow.current_address : ""
                horizontalAlignment: TextInput.AlignHCenter
                wrapMode: Text.Wrap
                textFormat: Text.RichText
                color: selectedAddressMouseArea.containsMouse ? MoneroComponents.Style.orange : MoneroComponents.Style.defaultFontColor
                font.pixelSize: 15
                font.family: MoneroComponents.Style.fontRegular.name
                themeTransition: false
                tooltip: qsTr("Copy address to clipboard") + translationManager.emptyString
                MouseArea {
                    id: selectedAddressMouseArea
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onEntered: parent.tooltip ? parent.tooltipPopup.open() : ""
                    onExited: parent.tooltip ? parent.tooltipPopup.close() : ""
                    onClicked: {
                        clipboard.setText(appWindow.current_address);
                        appWindow.showStatusMessage(qsTr("Address copied to clipboard") + translationManager.emptyString, 3);
                    }
                }
            }

            MoneroComponents.StandardButton {
                Layout.preferredWidth: 220
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 18
                small: true
                text: qsTr("Show on device") + translationManager.emptyString
                fontSize: 14
                visible: appWindow.currentWallet ? appWindow.currentWallet.isHwBacked() : false
                onClicked: {
                    appWindow.currentWallet.deviceShowAddressAsync(
                        appWindow.currentWallet.currentSubaddressAccount,
                        appWindow.current_subaddress_table_index,
                        '');
                }
            }
        }

        ColumnLayout {
            id: addressRow
            spacing: 0

            RowLayout {
                spacing: 0

                MoneroComponents.LabelSubheader {
                    Layout.fillWidth: true
                    fontSize: 24
                    textFormat: Text.RichText
                    text: qsTr("Addresses") + translationManager.emptyString
                }

                MoneroComponents.StandardButton {
                    id: createAddressButton
                    small: true
                    text: qsTr("Create new address") + translationManager.emptyString
                    fontSize: 13
                    onClicked: {
                        inputDialog.labelText = qsTr("Set the label of the new address:") + translationManager.emptyString
                        inputDialog.onAcceptedCallback = function() {
                            appWindow.currentWallet.subaddress.addRow(appWindow.currentWallet.currentSubaddressAccount, inputDialog.inputText)
                            current_subaddress_table_index = appWindow.currentWallet.numSubaddresses(appWindow.currentWallet.currentSubaddressAccount) - 1
                            subaddressListView.currentIndex = current_subaddress_table_index
                        }
                        inputDialog.onRejectedCallback = null;
                        inputDialog.open()
                    }

                    Rectangle {
                        anchors.top: createAddressButton.bottom
                        anchors.topMargin: 8
                        anchors.left: createAddressButton.left
                        anchors.right: createAddressButton.right
                        height: 2
                        color: MoneroComponents.Style.appWindowBorderColor

                        MoneroEffects.ColorTransition {
                            targetObj: parent
                            blackColor: MoneroComponents.Style._b_appWindowBorderColor
                            whiteColor: MoneroComponents.Style._w_appWindowBorderColor
                        }
                    }
                }
            }

            ColumnLayout {
                id: subaddressListRow
                property int subaddressListItemHeight: 50
                Layout.topMargin: 6
                Layout.fillWidth: true
                Layout.minimumWidth: 240
                Layout.preferredHeight: subaddressListItemHeight * subaddressListView.count
                visible: subaddressListView.count >= 1

                ListView {
                    id: subaddressListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    boundsBehavior: ListView.StopAtBounds
                    interactive: false

                    delegate: Rectangle {
                        id: tableItem2
                        height: subaddressListRow.subaddressListItemHeight
                        width: parent ? parent.width : undefined
                        Layout.fillWidth: true
                        color: itemMouseArea.containsMouse || index === appWindow.current_subaddress_table_index ? MKEcoinComponents.Style.titleBarButtonHoverColor : "transparent"

                        Rectangle {
                            visible: index === appWindow.current_subaddress_table_index
                            Layout.fillHeight: true
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            color: "darkgrey"
                            width: 2
                        }

                        Rectangle{
                            anchors.right: parent.right
                            anchors.left: parent.left
                            anchors.top: parent.top
                            height: 1
                            color: MKEcoinComponents.Style.appWindowBorderColor
                            visible: index !== 0

                            MKEcoinEffects.ColorTransition {
                                targetObj: parent
                                blackColor: MKEcoinComponents.Style._b_appWindowBorderColor
                                whiteColor: MKEcoinComponents.Style._w_appWindowBorderColor
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            anchors.topMargin: 5
                            anchors.rightMargin: 90
                            color: "transparent"

                            MKEcoinComponents.Label {
                                id: idLabel
                                color: index === appWindow.current_subaddress_table_index ? MKEcoinComponents.Style.defaultFontColor : "#757575"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 6
                                fontSize: 16
                                text: "#" + index
                                themeTransition: false
                            }

                            MKEcoinComponents.Label {
                                id: nameLabel
                                color: index === appWindow.current_subaddress_table_index ? MKEcoinComponents.Style.defaultFontColor : MKEcoinComponents.Style.dimmedFontColor
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: idLabel.right
                                anchors.leftMargin: 6
                                fontSize: 16
                                text: label
                                elide: Text.ElideRight
                                textWidth: addressLabel.x - nameLabel.x - 1
                                themeTransition: false
                            }

                            MKEcoinComponents.Label {
                                id: addressLabel
                                color: MKEcoinComponents.Style.defaultFontColor
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.right
                                anchors.leftMargin: -addressLabel.width - 5
                                fontSize: 16
                                fontFamily: MKEcoinComponents.Style.fontMonoRegular.name;
                                text: TxUtils.addressTruncatePretty(address, mainLayout.width < 520 ? 1 : (mainLayout.width < 650 ? 2 : 3))
                                themeTransition: false
                            }

                            MouseArea {
                                id: itemMouseArea
                                cursorShape: Qt.PointingHandCursor
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: subaddressListView.currentIndex = index;
                            }
                        }

                        RowLayout {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 6
                            height: 21
                            spacing: 10

                            MKEcoinComponents.IconButton {
                                fontAwesomeFallbackIcon: FontAwesome.searchPlus
                                fontAwesomeFallbackSize: 22
                                color: MKEcoinComponents.Style.defaultFontColor
                                fontAwesomeFallbackOpacity: 0.5
                                Layout.preferredWidth: 23
                                Layout.preferredHeight: 21
                                tooltip: qsTr("See transactions") + translationManager.emptyString

                                onClicked: doSearchInHistory(address)
                            }

                            MKEcoinComponents.IconButton {
                                id: renameButton
                                image: "qrc:///images/edit.svg"
                                fontAwesomeFallbackIcon: FontAwesome.edit
                                fontAwesomeFallbackSize: 22
<<<<<<< HEAD
                                color: MKEcoinComponents.Style.defaultFontColor
                                opacity: 0.5
=======
                                color: MoneroComponents.Style.defaultFontColor
                                opacity: isOpenGL ? 0.5 : 1
                                fontAwesomeFallbackOpacity: 0.5
>>>>>>> b6682330a6f87051c523c05b9b653eb494760003
                                Layout.preferredWidth: 23
                                Layout.preferredHeight: 21
                                visible: index !== 0
                                tooltip: qsTr("Edit address label") + translationManager.emptyString

                                onClicked: {
                                    renameSubaddressLabel(index);
                                }
                            }

                            MKEcoinComponents.IconButton {
                                id: copyButton
                                image: "qrc:///images/copy.svg"
                                fontAwesomeFallbackIcon: FontAwesome.clipboard
                                fontAwesomeFallbackSize: 22
<<<<<<< HEAD
                                color: MKEcoinComponents.Style.defaultFontColor
                                opacity: 0.5
=======
                                color: MoneroComponents.Style.defaultFontColor
                                opacity: isOpenGL ? 0.5 : 1
                                fontAwesomeFallbackOpacity: 0.5
>>>>>>> b6682330a6f87051c523c05b9b653eb494760003
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 21
                                tooltip: qsTr("Copy address to clipboard") + translationManager.emptyString

                                onClicked: {
                                    console.log("Address copied to clipboard");
                                    clipboard.setText(address);
                                    appWindow.showStatusMessage(qsTr("Address copied to clipboard"),3);
                                }
                            }
                        }
                    }
                    onCurrentItemChanged: {
                        // reset global vars
                        appWindow.current_subaddress_table_index = subaddressListView.currentIndex;
                        appWindow.current_address = appWindow.currentWallet.address(
                            appWindow.currentWallet.currentSubaddressAccount,
                            subaddressListView.currentIndex
                        );
                        if (subaddressListView.currentIndex == 0) {
                            selectedAddressDrescription.text = qsTr("Primary address") + translationManager.emptyString;
                        } else {
                            var selectedAddressLabel = appWindow.currentWallet.getSubaddressLabel(appWindow.currentWallet.currentSubaddressAccount, appWindow.current_subaddress_table_index);
                            if (selectedAddressLabel == "") {
                                selectedAddressDrescription.text = "(" + qsTr("no label") + ")" + translationManager.emptyString
                            } else {
                                selectedAddressDrescription.text = selectedAddressLabel
                            }
                        }
                    }
                }
            }

            Rectangle {
                color: MKEcoinComponents.Style.appWindowBorderColor
                Layout.fillWidth: true
                height: 1

                MKEcoinEffects.ColorTransition {
                    targetObj: parent
                    blackColor: MKEcoinComponents.Style._b_appWindowBorderColor
                    whiteColor: MKEcoinComponents.Style._w_appWindowBorderColor
                }
            }
<<<<<<< HEAD

            MKEcoinComponents.CheckBox {
                id: addNewAddressCheckbox
                border: false
                uncheckedIcon: FontAwesome.plusCircle
                toggleOnClick: false
                fontAwesomeIcons: true
                fontSize: 16
                iconOnTheLeft: true
                Layout.fillWidth: true
                Layout.topMargin: 10
                text: qsTr("Create new address") + translationManager.emptyString;
                onClicked: {
                    inputDialog.labelText = qsTr("Set the label of the new address:") + translationManager.emptyString
                    inputDialog.onAcceptedCallback = function() {
                        appWindow.currentWallet.subaddress.addRow(appWindow.currentWallet.currentSubaddressAccount, inputDialog.inputText)
                        current_subaddress_table_index = appWindow.currentWallet.numSubaddresses(appWindow.currentWallet.currentSubaddressAccount) - 1
                        subaddressListView.currentIndex = current_subaddress_table_index
                    }
                    inputDialog.onRejectedCallback = null;
                    inputDialog.open()
                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 11
            property int qrSize: 220

            Rectangle {
                id: qrContainer
                color: MKEcoinComponents.Style.blackTheme ? "white" : "transparent"
                Layout.fillWidth: true
                Layout.maximumWidth: parent.qrSize
                Layout.preferredHeight: width
                radius: 4

                Image {
                    id: qrCode
                    anchors.fill: parent
                    anchors.margins: 1

                    smooth: false
                    fillMode: Image.PreserveAspectFit
                    source: "image://qrcode/" + TxUtils.makeQRCodeString(appWindow.current_address)

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton
                        onPressAndHold: qrFileDialog.open()
                    }
                }
            }

            MKEcoinComponents.StandardButton {
                Layout.preferredWidth: 220
                small: true
                text: FontAwesome.save + "  %1".arg(qsTr("Save as image")) + translationManager.emptyString
                label.font.family: FontAwesome.fontFamily
                fontSize: 13
                onClicked: qrFileDialog.open()
            }

            MKEcoinComponents.StandardButton {
                Layout.preferredWidth: 220
                small: true
                text: FontAwesome.eye + "  %1".arg(qsTr("Show on device")) + translationManager.emptyString
                label.font.family: FontAwesome.fontFamily
                fontSize: 13
                visible: appWindow.currentWallet ? appWindow.currentWallet.isHwBacked() : false
                onClicked: {
                    appWindow.currentWallet.deviceShowAddressAsync(
                        appWindow.currentWallet.currentSubaddressAccount,
                        appWindow.current_subaddress_table_index,
                        '');
                }
            }
=======
>>>>>>> b6682330a6f87051c523c05b9b653eb494760003
        }

        MessageDialog {
            id: receivePageDialog
            standardButtons: StandardButton.Ok
        }

        FileDialog {
            id: qrFileDialog
            title: qsTr("Please choose a name") + translationManager.emptyString
            folder: shortcuts.pictures
            selectExisting: false
            nameFilters: ["Image (*.png)"]
            onAccepted: {
                if(!walletManager.saveQrCode(TxUtils.makeQRCodeString(appWindow.current_address), walletManager.urlToLocalPath(fileUrl))) {
                    console.log("Failed to save QrCode to file " + walletManager.urlToLocalPath(fileUrl) )
                    receivePageDialog.title = qsTr("Save QrCode") + translationManager.emptyString;
                    receivePageDialog.text = qsTr("Failed to save QrCode to ") + walletManager.urlToLocalPath(fileUrl) + translationManager.emptyString;
                    receivePageDialog.icon = StandardIcon.Error
                    receivePageDialog.open()
                }
            }
        }
    }

    function onPageCompleted() {
        console.log("Receive page loaded");
        subaddressListView.model = appWindow.currentWallet.subaddressModel;

        if (appWindow.currentWallet) {
            appWindow.current_address = appWindow.currentWallet.address(appWindow.currentWallet.currentSubaddressAccount, 0)
            appWindow.currentWallet.subaddress.refresh(appWindow.currentWallet.currentSubaddressAccount)
            if (subaddressListView.currentIndex == -1) {
                subaddressListView.currentIndex = 0;
            }
        }
    }

    function clearFields() {
        // @TODO: add fields
    }

    function onPageClosed() {
    }
}
