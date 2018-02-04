/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#ifndef PLAYERSMODEL_H
#define PLAYERSMODEL_H

#include <QSqlTableModel>
#include <QSqlDatabase>
#include <QHash>
#include <QSet>
#include <QUrl>

class PlayersModel : public QSqlTableModel
{
    Q_OBJECT
    Q_PROPERTY(bool empty READ isEmpty NOTIFY emptyChanged)
public:
    enum Role {
        Id = Qt::UserRole + 1,
        FirstName,
        LastName,
        PhotoUrl
    };

    PlayersModel( QObject* parent = nullptr, QSqlDatabase db = QSqlDatabase() );
    ~PlayersModel() override = default;

    void reload();

    void hidePlayer( int id );
    void exposePlayer( int id );

    Q_INVOKABLE bool addPlayer( const QString& firstName, const QString& lastName );
    Q_INVOKABLE bool editPlayer( int playerId, const QString& firstName, const QString& lastName );
    Q_INVOKABLE QVariant data( const QModelIndex &index, int role = Qt::DisplayRole ) const override;
    QHash<int, QByteArray> roleNames() const override;

protected slots:
    bool isEmpty() const;

signals:
    void playerAdded();
    void playerEdited();
    void emptyChanged(bool empty);

private:
    void applyHiddenPlayersFilter();
    QVariant getPhotoUrl( int playerId ) const;

    QSet<int> hiddenPlayersIds_;
};

#endif // PLAYERSMODEL_H
