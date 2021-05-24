import QtQuick 2.9

import "../components" as MKEcoinComponents

TextEdit {
    color: MKEcoinComponents.Style.defaultFontColor
    font.family: MKEcoinComponents.Style.fontRegular.name
    selectionColor: MKEcoinComponents.Style.textSelectionColor
    wrapMode: Text.Wrap
    readOnly: true
    selectByMouse: true
    // Workaround for https://bugreports.qt.io/browse/QTBUG-50587
    onFocusChanged: {
        if(focus === false)
            deselect()
    }
}
