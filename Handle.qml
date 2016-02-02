import QtQuick 2.0

Rectangle {
    id: root
    property bool pressed: false
    radius: width * .5
    opacity: pressed ? 1 : 0
    MouseArea{id: rootArea; anchors.fill: parent; onPressed: {mouse.accepted= false; root.pressed = true}}
}

