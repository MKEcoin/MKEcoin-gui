import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1

import FontAwesome 1.0
import "../components" as mkecoinComponents

MenuItem {
    id: menuItem

    property bool glyphIconSolid: true
    property alias glyphIcon: glyphIcon.text

    background: Rectangle {
        color: mkecoinComponents.Style.buttonBackgroundColorDisabledHover
        opacity: mouse.containsMouse ? 1 : 0

        MouseArea {
            id: mouse

            anchors.fill: parent
            hoverEnabled: true
            onClicked: menuItem.triggered()
            visible: menuItem.enabled
        }
    }

    contentItem: RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        opacity: menuItem.enabled ? 1 : 0.4
        spacing: 8

        Text {
            id: glyphIcon

            color: mkecoinComponents.Style.buttonTextColor
            font.family: glyphIconSolid ? FontAwesome.fontFamilySolid : FontAwesome.fontFamily
            font.pixelSize: 14
            font.styleName: glyphIconSolid ? "Solid" : "Regular"
        }

        Text {
            color: mkecoinComponents.Style.buttonTextColor
            font.family: mkecoinComponents.Style.fontRegular.name
            font.pixelSize: 14
            Layout.fillWidth: true
            text: menuItem.text
        }
    }
}
