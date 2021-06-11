import QtQuick 2.9

import "." as mkecoinComponents
import "effects/" as mkecoinEffects

Rectangle {
    color: mkecoinComponents.Style.appWindowBorderColor
    height: 1

    mkecoinEffects.ColorTransition {
        targetObj: parent
        blackColor: mkecoinComponents.Style._b_appWindowBorderColor
        whiteColor: mkecoinComponents.Style._w_appWindowBorderColor
    }
}
