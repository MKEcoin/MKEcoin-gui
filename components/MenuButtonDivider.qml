import QtQuick 2.9

import "." as MKEcoinComponents
import "effects/" as MKEcoinEffects

Rectangle {
    color: MKEcoinComponents.Style.appWindowBorderColor
    height: 1

    MKEcoinEffects.ColorTransition {
        targetObj: parent
        blackColor: MKEcoinComponents.Style._b_appWindowBorderColor
        whiteColor: MKEcoinComponents.Style._w_appWindowBorderColor
    }
}
