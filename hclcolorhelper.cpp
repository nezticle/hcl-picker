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

#include "hclcolorhelper.h"
#include <QtMath>

HCLColorHelper::HCLColorHelper(QObject *parent) : QObject(parent)
{

}

namespace {
double finv(double t) {
    if (t > (6.0 / 29.0)) {
        return t * t * t;
    } else {
        return 3 * (6.0 / 29.0) * (6.0 / 29.0) * (t - 4.0 / 29.0);
    }
}

double correct(double cl) {
    double a = 0.055;
    if (cl <= 0.0031308) {
      return 12.92 * cl;
    } else {
      return (1 + a) * qPow(cl, 1 / 2.4) - a;
    }
}
}

QColor HCLColorHelper::hclToRgb(double hue, double chroma, double lightness)
{
    // Convert to Lab color space
    const double TAU = 6.283185307179586476925287;
    hue /= 360;
    double l = lightness * 0.61 + 0.09;
    double angle = TAU / 6.0 - hue * TAU;
    double r = (lightness * 0.311 + 0.125) * chroma;
    double a = qSin(angle) * r;
    double b = qCos(angle) * r;

    // Convert to XYZ
    double sl = (l + 0.16) / 1.16;
    double y = finv(sl);
    double x = 0.96421 * finv(sl + (a / 5.0));
    double z = 0.82519 * finv(sl - (b / 2.0));

    // Convert to RGB
    double rl = 3.2406 * x - 1.5372 * y - 0.4986 * z;
    double gl = -0.9689 * x + 1.8758 * y + 0.0415 * z;
    double bl = 0.0557 * x - 0.2040 * y + 1.0570 * z;
    bool clip = qMin(qMin(rl, gl), bl) < -0.001 || qMax(qMax(rl, gl), bl) > 1.001;
    int alpha = 255;
    if (clip) {
        rl = rl < 0.0 ? 0.0 : rl > 1.0 ? 1.0 : rl;
        gl = gl < 0.0 ? 0.0 : gl > 1.0 ? 1.0 : gl;
        bl = bl < 0.0 ? 0.0 : bl > 1.0 ? 1.0 : bl;
        alpha = 0;
    }
    int red = qRound(255.0 * correct(rl));
    int green = qRound(255.0 * correct(gl));
    int blue = qRound(255.0 * correct(bl));
    return QColor(red, green, blue, alpha);
}

int HCLColorHelper::getRed(const QColor &color) const
{
    return color.red();
}

int HCLColorHelper::getGreen(const QColor &color) const
{
    return color.green();
}

int HCLColorHelper::getBlue(const QColor &color) const
{
    return color.blue();
}

QString HCLColorHelper::colorToString(const QColor &color)
{
    return color.name();
}
