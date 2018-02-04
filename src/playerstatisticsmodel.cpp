/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#include <QSqlError>
#include <QDateTime>
#include "playerstatisticsmodel.h"

PlayerStatisticsModel::PlayerStatisticsModel( QObject* parent )
    : QSqlQueryModel( parent )
{}

QVariant PlayerStatisticsModel::data( const QModelIndex& index, int role ) const
{
    if(index.row() >= rowCount())
        return QStringLiteral("");

    if(role < Qt::UserRole)
        return QSqlQueryModel::data( index, role );

    auto result = QSqlQueryModel::data( this->index( index.row(), role - Qt::UserRole - 1 ),
                                        Qt::DisplayRole );

    if (role == GameDate)
        return QDateTime::fromSecsSinceEpoch( result.toInt() ).toString( "dd.MM.yyyy" );
    else
        return result;
}

QHash<int, QByteArray> PlayerStatisticsModel::roleNames() const
{
    static QHash<int, QByteArray> roles {
        { GameDate, QByteArrayLiteral("GameDate") },
        { Goals,    QByteArrayLiteral("Goals")    }
    };

    return roles;
}

void PlayerStatisticsModel::loadPlayer( int playerId )
{
    setQuery( QString( "SELECT  m.date AS date, s.goals AS goals "
                       "FROM stats s "
                       "INNER JOIN match m ON m.id = s.match_id "
                       "WHERE s.player_id = %1 "
                       "GROUP BY m.date" ).arg( playerId ));

    if (lastError().isValid())
        qDebug( "PlayerStatisticsModel error: %s", qPrintable( lastError().text() ));
}
