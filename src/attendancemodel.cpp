/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#include <QSqlError>
#include <QDateTime>
#include "attendancemodel.h"

AttendanceModel::AttendanceModel( QObject* parent )
    : QSqlQueryModel( parent )
{
    reload();
}

QVariant AttendanceModel::data( const QModelIndex& index, int role ) const
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

QHash<int, QByteArray> AttendanceModel::roleNames() const
{
    static QHash<int, QByteArray> roles {
        { GameDate,     QByteArrayLiteral("GameDate")    },
        { PlayersCount, QByteArrayLiteral("PlayersCount") }
    };

    return roles;
}

void AttendanceModel::reload()
{
    setQuery( "SELECT  m.date AS date, "
              "COUNT(s.match_id) AS total_players "
              "FROM match m "
              "INNER JOIN stats s ON s.match_id = m.id "
              "GROUP BY m.date" );

    if (lastError().isValid())
        qDebug( "AttendanceStatisticsModel error: %s", qPrintable( lastError().text() ));
}
