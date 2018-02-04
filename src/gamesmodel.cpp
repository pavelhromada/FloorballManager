/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#include <QDateTime>
#include "gamesmodel.h"

GamesModel::GamesModel( QObject* parent )
    : QSqlTableModel( parent )
{
    setTable( "match" );
    select();
}

QVariant GamesModel::data( const QModelIndex& index, int role ) const
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

QHash<int, QByteArray> GamesModel::roleNames() const
{
    static QHash<int, QByteArray> roles {
        { Id,          QByteArrayLiteral("Id")          },
        { GameDate,    QByteArrayLiteral("GameDate")    },
        { GoalsTeamA,  QByteArrayLiteral("GoalsTeamA")  },
        { GoalsTeamB,  QByteArrayLiteral("GoalsTeamB")  }
    };

    return roles;
}
