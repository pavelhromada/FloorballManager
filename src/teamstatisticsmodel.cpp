/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#include <QSqlError>
#include <QDateTime>
#include "teamstatisticsmodel.h"

TeamStatisticsModel::TeamStatisticsModel(bool teamA, QObject* parent )
    : QSqlQueryModel( parent )
    , teamA_( teamA )
{}

QVariant TeamStatisticsModel::data( const QModelIndex& index, int role ) const
{
    if(index.row() >= rowCount())
        return QStringLiteral("");

    if(role < Qt::UserRole)
        return QSqlQueryModel::data( index, role );

    auto result =  QSqlQueryModel::data( this->index( index.row(), role - Qt::UserRole - 1 ),
                                         Qt::DisplayRole );

    if (role == GameDate)
        return QDateTime::fromSecsSinceEpoch( result.toInt() ).toString( "dd.MM.yyyy" );
    else
        return result;
}

QHash<int, QByteArray> TeamStatisticsModel::roleNames() const
{
    static QHash<int, QByteArray> roles {
        { GameDate,  QByteArrayLiteral("GameDate")  },
        { FirstName, QByteArrayLiteral("FirstName") },
        { LastName,  QByteArrayLiteral("LastName")  },
        { Goals,     QByteArrayLiteral("Goals")     }
    };

    return roles;
}

void TeamStatisticsModel::loadMatch( int matchId )
{
    setQuery( QString("SELECT s.goals as goals, m.date as date, p.firstname, p.lastname "
                      "FROM stats s "
                      "INNER JOIN match m ON m.id = s.match_id "
                      "INNER JOIN player p ON p.id = s.player_id "
                      "WHERE s.team = %1 AND s.match_id = %2")
              .arg( teamA_ ? 0 : 1 )
              .arg( matchId ));

    if (lastError().isValid())
        qDebug( "TeamStatisticsModel error: %s", qPrintable( lastError().text() ));
}
