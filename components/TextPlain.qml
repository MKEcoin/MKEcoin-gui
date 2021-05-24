import QtQuick 2.9

import "." as MKEcoinComponents
import "effects/" as MKEcoinEffects

Text {
    // When using this component, please note that if you use a color different
    // than `defaultFontColor`, you are required to also define `themeTransitionXColor`.
    // If you do not set these the component will receive the wrong color after a transition.
    // If you do not want to set these, use `themeTransition: false`.
    id: root
    property bool themeTransition: true
    property string themeTransitionBlackColor: ""
    property string themeTransitionWhiteColor: ""
    property alias tooltip: tooltip.text
    font.family: MKEcoinComponents.Style.fontMedium.name
    font.bold: false
    font.pixelSize: 14
    textFormat: Text.PlainText

    MKEcoinEffects.ColorTransition {
        enabled: root.themeTransition
        themeTransition: root.themeTransition
        targetObj: root
        duration: 750
        blackColor: root.themeTransitionBlackColor !== "" ? root.themeTransitionBlackColor : MKEcoinComponents.Style._b_defaultFontColor
        whiteColor: root.themeTransitionWhiteColor !== "" ? root.themeTransitionWhiteColor : MKEcoinComponents.Style._w_defaultFontColor
    }

    MKEcoinComponents.Tooltip {
        id: tooltip
        anchors.top: parent.top
        anchors.left: parent.right
    }
}