import QtQuick 2.9

import "../components" as mkecoinComponents

TextEdit {
    color: mkecoinComponents.Style.defaultFontColor
    font.family: mkecoinComponents.Style.fontRegular.name
    selectionColor: mkecoinComponents.Style.textSelectionColor
    wrapMode: Text.Wrap
    readOnly: true
    selectByMouse: true
    // Workaround for https://bugreports.qt.io/browse/QTBUG-50587
    onFocusChanged: {
        if(focus === false)
            deselect()
    }
}
