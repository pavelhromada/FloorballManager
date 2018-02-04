/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#include <QSqlRecord>
#include <QStandardPaths>
#include <QFile>
#include "teammodel.h"

TeamModel::TeamModel( QObject* parent )
    : QSqlTableModel( parent )
{
    setTable( "player" );
    resetTeam();
    select();
}

void TeamModel::resetTeam()
{
    // By default 0 players from 'player' table will be in team.
    goals_.clear();
    playersIds_.clear();
    setFilter( QStringLiteral( "id IN ()" ));
}

void TeamModel::removePlayer( int id )
{
    if (playersIds_.remove( id )) {
        goals_.remove( id );
        applyHiddenPlayersFilter();
    }
}

void TeamModel::addPlayer( int id )
{
    if (playersIds_.contains( id ))
        return;

    playersIds_.insert( id );
    goals_[ id ] = 0;
    applyHiddenPlayersFilter();
}

void TeamModel::setPlayerGoals( int id, int goals )
{
    if (goals_.contains( id ))
        goals_[ id ] = goals;
}

QVariant TeamModel::data( const QModelIndex& index, int role ) const
{
    if(index.row() >= rowCount())
        return QStringLiteral("");

    if(role < Qt::UserRole)
        return QSqlQueryModel::data( index, role );

    if (role == PhotoUrl) {
        int id = QSqlQueryModel::data( this->index( index.row(), Id - Qt::UserRole - 1 ),
                                       Qt::DisplayRole ).toInt();
        return getPhotoUrl( id );
    }

    if (role == Goals) {
        int id = QSqlQueryModel::data( this->index( index.row(), Id - Qt::UserRole - 1 ),
                                       Qt::DisplayRole ).toInt();
        return goals_.value( id, 0 );
    }

    return QSqlQueryModel::data( this->index( index.row(), role - Qt::UserRole - 1 ),
                                 Qt::DisplayRole );
}

QHash<int, QByteArray> TeamModel::roleNames() const
{
    static QHash<int, QByteArray> roles {
        { Id,        QByteArrayLiteral("Id")        },
        { FirstName, QByteArrayLiteral("FirstName") },
        { LastName,  QByteArrayLiteral("LastName")  },
        { PhotoUrl,  QByteArrayLiteral("PhotoUrl")  },
        { Goals,     QByteArrayLiteral("Goals")     }
    };

    return roles;
}

void TeamModel::applyHiddenPlayersFilter()
{
    QString filterIds;
    for (auto id : qAsConst( playersIds_ ))
        filterIds.append( QString::number( id )).append( ',' );

    if (!filterIds.isEmpty())
        filterIds.remove( filterIds.length() - 1, 1 );

    setFilter( QString( "id IN (%1)" ).arg( filterIds ));
}

QVariant TeamModel::getPhotoUrl( int playerId ) const
{
    auto photoLocation = QStandardPaths::writableLocation( QStandardPaths::AppLocalDataLocation );
    photoLocation.append( "/photo" );
    photoLocation.append( QString("/%1.png").arg( QString::number( playerId )));

    if (QFile::exists( photoLocation ))
        return QUrl::fromLocalFile( photoLocation );

    return QVariant();
}
