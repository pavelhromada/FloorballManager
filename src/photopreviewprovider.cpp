/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#include "photopreviewprovider.h"

PhotoPreviewProvider::PhotoPreviewProvider()
    : QQuickImageProvider( QQuickImageProvider::Image )
{}

void PhotoPreviewProvider::updatePreview( const QImage& image )
{
    photoPreview_ = image;
}

bool PhotoPreviewProvider::savePreview( const QString& path )
{
    if (photoPreview_.isNull())
        return false;

    return photoPreview_.save( path );
}

QImage PhotoPreviewProvider::requestImage( const QString& id, QSize* size, const QSize& )
{
    if (id != "photoPreview")
        return QImage();

    *size = photoPreview_.size();
    return photoPreview_;
}
