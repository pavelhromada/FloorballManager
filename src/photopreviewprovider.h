/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#ifndef PHOTOPREVIEWPROVIDER_H
#define PHOTOPREVIEWPROVIDER_H

#include <QQuickImageProvider>

class QQmlEngine;

class PhotoPreviewProvider : public QQuickImageProvider
{
public:
    PhotoPreviewProvider();

    void updatePreview( const QImage& image );
    bool savePreview( const QString& path );
    QImage requestImage( const QString& id, QSize* size, const QSize& requestedSize ) override;

private:
    QImage photoPreview_;
};

#endif // PHOTOPREVIEWPROVIDER_H
