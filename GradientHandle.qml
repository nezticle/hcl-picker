/*
 * Copyright (c) 2020 Andy Nichols <nezticle@gmail.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

import QtQuick 2.15

Rectangle {
    id: gradientHandle
    property var container: undefined
    property point origin: Qt.point(x + width * 0.5, y + height * 0.5)
//    x: -height * 0.5
//    y: -height * 0.5
    height: 30
    width: height
    radius: height * 0.5
    border.color: "white"
    border.width: 1
    color: "black"
    MouseArea {
        anchors.fill: parent
        drag.target: parent
        drag.axis: Drag.XAndYAxis
        drag.minimumX: - (parent.width * 0.5)
        drag.minimumY: - (parent.height * 0.5)
        drag.maximumX: container.width - (parent.width * 0.5)
        drag.maximumY: container.height - (parent.height * 0.5)
    }
    onOriginChanged: {
        gradientHandle.color = container.colorAtPos(origin.x, origin.y);
    }

    Connections {
        target: container
        function onColorsUpdated() {
            gradientHandle.color = container.colorAtPos(origin.x, origin.y);
        }
    }
}

