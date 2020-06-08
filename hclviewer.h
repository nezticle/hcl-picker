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

#ifndef HCLVIEWER_H
#define HCLVIEWER_H

#include <QQuickPaintedItem>
#include <QImage>

class HCLViewer : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(ViewMode mode READ mode WRITE setMode NOTIFY modeChanged)
    Q_PROPERTY(float value READ value WRITE setValue NOTIFY valueChanged)
    QML_ELEMENT
public:
    enum ViewMode {
        HLC,
        CLH,
        HCL
    };
    Q_ENUM(ViewMode)

    HCLViewer();

    void paint(QPainter *painter) override;
    ViewMode mode() const;
    float value() const;

    Q_INVOKABLE QColor colorAtPos(int x, int y) const;

public slots:
    void setMode(ViewMode mode);
    void setValue(float value);

signals:
    void modeChanged(ViewMode mode);
    void valueChanged(float value);
    void colorsUpdated();

private:
    ViewMode m_mode = HLC;
    float m_value = 0.0f;
    QImage m_image;

};

#endif // HCLVIEWER_H
