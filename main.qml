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
 * 3. Neither the name of mosquitto nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
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
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import xyz.unparalleled.hclpicker 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("HCL Picker Demo")

    Item {
        id: hclPicker
        anchors.fill: parent
        RowLayout {
            anchors.fill: parent
            // Buttons
            ColumnLayout {
                Layout.alignment: Qt.AlignTop
                Button {
                    id: hlButton
                    text: "H-L"
                    onClicked: {
                        hclPicker.state = "h-l"
                    }
                    hoverEnabled: true
                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Hue-Lightness")
                }
                Button {
                    id: clButton
                    text: "C-L"
                    onClicked: {
                        hclPicker.state = "c-l"
                    }
                    hoverEnabled: true
                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Chroma-Lightness")
                }
                Button {
                    id: hcButton
                    text: "H-C"
                    onClicked: {
                        hclPicker.state = "h-c"
                    }
                    hoverEnabled: true
                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Hue-Chroma")
                }
            }
            ColumnLayout {
                RowLayout {
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        HCLViewer {
                            id: canvas
                            mode: HCLViewer.HLC
                            value: slider.value

                            anchors.centerIn: parent
                            width: parent.width < parent.height ? parent.width : parent.height
                            height: width

                            // Gradient Start and Stop
                            RectangleLine {
                                origin1: gradientStartHandle.origin
                                origin2: gradientStopHandle.origin
                            }

                            GradientHandle {
                                id: gradientStartHandle
                                container: canvas
                                onOriginChanged: {
                                    swatchListModel.updateSwatchModel()
                                }
                            }
                            GradientHandle {
                                id: gradientStopHandle
                                container: canvas
                                x: canvas.width * 0.5
                                y: canvas.height * 0.5
                                onOriginChanged: {
                                    swatchListModel.updateSwatchModel()
                                }
                            }

                            onColorsUpdated: {
                                swatchListModel.updateSwatchModel()
                            }

                            Component.onCompleted: {
                                swatchListModel.append({"swatchColor": "#000000"})
                                swatchListModel.append({"swatchColor": "#000000"})
                                swatchListModel.append({"swatchColor": "#000000"})
                                swatchListModel.append({"swatchColor": "#000000"})
                                swatchListModel.append({"swatchColor": "#000000"})
                                swatchListModel.append({"swatchColor": "#000000"})
                                swatchListModel.updateSwatchModel();
                            }

                            ListModel {
                                id: swatchListModel

                                function updateSwatchModel() {
                                    let startPos = gradientStartHandle.origin;
                                    let stopPos = gradientStopHandle.origin;

                                    let dx = stopPos.x - startPos.x;
                                    let dy = stopPos.y - startPos.y;
                                    let xInterval = dx / swatchListModel.count - 1;
                                    let yInterval = dy / swatchListModel.count - 1;


                                    for (var i = 0; i < swatchListModel.count; ++i) {
                                        if (i === 0)
                                            swatchListModel.setProperty(i, "swatchColor", HCLColorHelper.colorToString(canvas.colorAtPos(startPos.x, startPos.y)));
                                        else if (i === swatchListModel.count - 1)
                                            swatchListModel.setProperty(i, "swatchColor", HCLColorHelper.colorToString(canvas.colorAtPos(stopPos.x, stopPos.y)));
                                        else {
                                            let pointX = startPos.x + (i * xInterval);
                                            let pointY = startPos.y + (i * yInterval);
                                            swatchListModel.setProperty(i, "swatchColor", HCLColorHelper.colorToString(canvas.colorAtPos(pointX, pointY)))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    ColumnLayout {
                        Layout.minimumWidth : swatchControlsLayout.width
                        ListView {
                            id: swatchView
                            Layout.fillHeight: true
                            model: swatchListModel
                            delegate: Item {
                                width: swatchView.width
                                height: 25
                                RowLayout {
                                    Rectangle {
                                        height: 25
                                        width: 50
                                        color: swatchColor
                                    }
                                    Text {
                                        text: swatchColor
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                }
                            }
                        }
                        Button {
                            id: copyButton
                            text: "Copy"
                            Layout.minimumWidth: swatchControlsLayout.width
                            onClicked: {
                                // concatonate all the swatch values to the clipboard
                                let swatches = ""
                                for (var i = 0; i < swatchListModel.count; ++i) {
                                    swatches += swatchListModel.get(i).swatchColor
                                    if (i + 1 < swatchListModel.count)
                                        swatches += ","
                                }
                                Clipboard.setText(swatches)
                            }
                        }
                    }
                }
                RowLayout {
                    Slider {
                        id: slider
                        Layout.fillWidth: true
                    }
                    RowLayout {
                        id: swatchControlsLayout
                        Button {
                            id: addSwatchButton
                            text: "+"
                            onReleased: {
                                // Add Swatch
                                swatchListModel.insert(swatchListModel.count - 1, {"swatchColor": "#0000ff"})
                                swatchListModel.updateSwatchModel();
                            }
                        }
                        Button {
                            id: removeSwatchButton
                            text: "-"
                            enabled: swatchListModel.count > 2
                            onReleased: {
                                // Remove Swatch (unless there are only 2 left)
                                swatchListModel.remove(swatchListModel.count - 2);
                                swatchListModel.updateSwatchModel();
                            }
                        }
                    }
                }
                Label {
                    id: valueLabel
                    property string axis: ""
                    text: axis + " " + slider.value
                }
            }
        }
        state: "h-l"
        states: [
            State {
                name: "h-l"
                PropertyChanges {
                    target: hlButton
                    highlighted: true
                }
                PropertyChanges {
                    target: valueLabel
                    axis: "Chroma"
                }
                PropertyChanges {
                    target: slider
                    from: 0
                    to: 5
                    stepSize: 0.01
                }
                PropertyChanges {
                    target: canvas
                    mode: HCLViewer.HLC
                }
            },
            State {
                name: "c-l"
                PropertyChanges {
                    target: clButton
                    highlighted: true
                }
                PropertyChanges {
                    target: valueLabel
                    axis: "Hue"
                }
                PropertyChanges {
                    target: slider
                    from: 0
                    to: 360
                    stepSize: 1
                }
                PropertyChanges {
                    target: canvas
                    mode: HCLViewer.CLH
                }
            },
            State {
                name: "h-c"
                PropertyChanges {
                    target: hcButton
                    highlighted: true
                }
                PropertyChanges {
                    target: valueLabel
                    axis: "Lightness"
                }
                PropertyChanges {
                    target: slider
                    from: 0
                    to: 1.7
                    stepSize: 0.01
                }
                PropertyChanges {
                    target: canvas
                    mode: HCLViewer.HCL
                }
            }

        ]
    }
}
