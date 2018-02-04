/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#ifndef TEAMMODEL_H
#define TEAMMODEL_H

#include <QSqlTableModel>
#include <QVector>
#include <QSet>
#include <QUrl>

class TeamModel : public QSqlTableModel
{
    Q_OBJECT
public:
    enum Role {
        Id = Qt::UserRole + 1,
        FirstName,
        LastName,
        PhotoUrl,
        Goals
    };

    TeamModel( QObject* parent = nullptr );
    ~TeamModel() override = default;

    Q_INVOKABLE void resetTeam();
    Q_INVOKABLE void removePlayer( int id );
    Q_INVOKABLE void addPlayer( int id );
    Q_INVOKABLE void setPlayerGoals( int id, int goals );

    QVariant data( const QModelIndex &index, int role = Qt::DisplayRole ) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    void applyHiddenPlayersFilter();
    QVariant getPhotoUrl( int playerId ) const;

    QSet<int> playersIds_;
    QMap<int, int> goals_;
};

#endif // TEAMMODEL_H
