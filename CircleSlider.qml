import QtQuick 2.0

Canvas {
    id: root

    property real min: 10
    property real max: 70
    property color strokeColor: "red"
    property int lineWidth: 20
    property int handleSize: 40

    /*!
      \internal
      */
    property int _radius: (root.width  - root.lineWidth) * .5
    property int _centerX: root.width * .5
    property int _centerY: root.height * .5
    property int _handleRotCenterX : root._centerX - root.handleSize*.5
    property int _handleRotCenterY : root._centerY - root.handleSize*.5
    property real _oldValue: 0

    anchors.fill: parent
    anchors.margins: 48

    onMaxChanged: {
        requestPaint()
    }
    onMinChanged: {
        requestPaint()
    }
    onPaint: drawCircle()

    function drawCircle() {
        var ctx = root.getContext("2d");
        var startArcPt = root.min * .01 * (2*Math.PI)
        var endArcPt = root.max * .01 * (2*Math.PI)

        ctx.clearRect(0,0,root.width, root.height)
        ctx.strokeStyle = root.strokeColor
        ctx.lineWidth = root.lineWidth
        ctx.beginPath()
        ctx.arc(root._centerX, root._centerY, root._radius, startArcPt, endArcPt)
        ctx.stroke()
    }

    function getAngle(mouse) {
        var localX = mouse.x - root._centerX
        var localY = mouse.y - root._centerY
        var value = 0

        // y [0; +Infinity] => atan2 [-PI; 0]
        // y [-Infinity; 0] => atan2 [0; PI]
        if(localY <= 0)
            value = (Math.atan2(localY, localX) + 2*Math.PI) * 100 / (2*Math.PI)
        else
            value = Math.atan2(localY, localX) * 100 / (2*Math.PI)

        return value
    }

    function moveHandle(value, mouse) {
        if(minHandle.pressed)
            root.min = value
        else if(maxHandle.pressed)
            root.max = value
        else {
            var offSet = value - root._oldValue
            root.max += offSet
            root.min += offSet
            root._oldValue = value
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onPressed:       {
            root._oldValue = getAngle(mouse)
            root.moveHandle(root._oldValue, mouse)
        }
        onMouseXChanged: root.moveHandle(getAngle(mouse), mouse)
        onMouseYChanged: root.moveHandle(getAngle(mouse), mouse)
        onReleased: {
            minHandle.pressed = false
            maxHandle.pressed = false
        }
    }

    Handle {
        id: minHandle
        width: root.handleSize
        height: root.handleSize
        color: Qt.darker(root.strokeColor)
        x: root._radius * Math.cos((2*Math.PI*root.min)/100) + root._handleRotCenterX
        y: root._radius * Math.sin((2*Math.PI*root.min)/100) + root._handleRotCenterY
    }

    Handle {
        id: maxHandle
        width: root.handleSize
        height: root.handleSize
        color: Qt.darker(root.strokeColor)
        x: root._radius * Math.cos((2*Math.PI*root.max)/100) + root._handleRotCenterX
        y: root._radius * Math.sin((2*Math.PI*root.max)/100) + root._handleRotCenterY
    }
}
