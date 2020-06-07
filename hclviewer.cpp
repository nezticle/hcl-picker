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

#include "hclviewer.h"
#include <QImage>
#include <QPainter>
#include "hclcolorhelper.h"

const int sampleSize = 210;

HCLViewer::HCLViewer()
    : m_image(sampleSize, sampleSize, QImage::Format_ARGB32)
{

}

void HCLViewer::paint(QPainter *painter)
{
    // Render stuff here
    for (int y = 0; y < sampleSize; ++y) {
        for (int x = 0; x < sampleSize; ++x) {
            double h = 0;
            double l = 0;
            double c = 0;

            if (m_mode == ViewMode::HCL) {
                h = double(x) / sampleSize * 360;
                c = double(y) / sampleSize * 5;
                l = m_value;
            } else if (m_mode == ViewMode::CLH) {
                c = double(x) / sampleSize * 5;
                l = double(y) / sampleSize * 1.7;
                h = m_value;
            } else if (m_mode == ViewMode::HLC) {
                h = double(x) / sampleSize * 360;
                l = double(y) / sampleSize * 1.7;
                c = m_value;
            }
            auto color = HCLColorHelper::hclToRgb(h, c, l);
            m_image.setPixel(x, y, color.rgba());
        }
    }
    emit colorsUpdated();

    painter->drawImage(this->boundingRect(), m_image);
}

HCLViewer::ViewMode HCLViewer::mode() const
{
    return m_mode;
}

float HCLViewer::value() const
{
    return m_value;
}

QColor HCLViewer::colorAtPos(int x, int y) const
{
    int xPos = x / width() * sampleSize;
    int yPos = y / height() * sampleSize;
    if (xPos < 0 || xPos > sampleSize || yPos < 0 || yPos > sampleSize)
        return QColor();
    auto color =  m_image.pixelColor(xPos, yPos);
    if (color.alpha() == 0)
        return QColor();

    return color;
}

void HCLViewer::setMode(HCLViewer::ViewMode mode)
{
    if (m_mode == mode)
        return;

    m_mode = mode;
    emit modeChanged(m_mode);
    update();
}

void HCLViewer::setValue(float value)
{
    if (qFuzzyCompare(m_value, value))
        return;

    m_value = value;
    emit valueChanged(m_value);
    update();
}
