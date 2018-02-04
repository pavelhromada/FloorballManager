/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#include <QSqlRecord>
#include <QSqlError>
#include <QStandardPaths>
#include <QSqlQuery>
#include <QFile>
#include "playersmodel.h"

PlayersModel::PlayersModel( QObject* parent , QSqlDatabase db )
    : QSqlTableModel( parent, db )
{
    setTable( "player" );
    setEditStrategy( QSqlTableModel::OnManualSubmit );
    select();
}

void PlayersModel::reload()
{
    beginResetModel();
    endResetModel();
    select();
    emit emptyChanged( isEmpty() );
}

void PlayersModel::hidePlayer( int id )
{
    if (hiddenPlayersIds_.contains( id ))
        return;

    hiddenPlayersIds_.insert( id );
    applyHiddenPlayersFilter();
}

void PlayersModel::exposePlayer( int id )
{
    if (hiddenPlayersIds_.remove( id ))
        applyHiddenPlayersFilter();
}

bool PlayersModel::addPlayer( const QString& firstName, const QString& lastName )
{
    // TODO check if firstname + lastname exists

    if (firstName.isEmpty() || lastName.isEmpty())
        return false;

    QSqlRecord rec = record();
    rec.setValue( QStringLiteral("firstname"), firstName );
    rec.setValue( QStringLiteral("lastname"), lastName );
    insertRecord( rowCount(), rec );

    if(!submitAll()) {
        database().rollback();
        qDebug( "floorball database error: %s", qPrintable( lastError().text() ));
        return false;
    }

    database().commit();
    emit playerAdded();
    emit emptyChanged( isEmpty() );

    return true;
}

bool PlayersModel::editPlayer( int playerId, const QString& firstName, const QString& lastName )
{
    QString sql = QString( "UPDATE player SET firstname = '%1', lastname= '%2' WHERE id = %3" )
            .arg( firstName )
            .arg( lastName )
            .arg( playerId );

    QSqlQuery query{ sql };

    select();

    return true;
}

QVariant PlayersModel::data( const QModelIndex& index, int role ) const
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

    return QSqlQueryModel::data( this->index( index.row(), role - Qt::UserRole - 1 ),
                                 Qt::DisplayRole );
}

QHash<int, QByteArray> PlayersModel::roleNames() const
{
    static QHash<int, QByteArray> roles {
        { Id,        QByteArrayLiteral("Id")        },
        { FirstName, QByteArrayLiteral("FirstName") },
        { LastName,  QByteArrayLiteral("LastName")  },
        { PhotoUrl,  QByteArrayLiteral("PhotoUrl")  }
    };

    return roles;
}

bool PlayersModel::isEmpty() const
{
    return rowCount() == 0;
}

void PlayersModel::applyHiddenPlayersFilter()
{
    QString filterIds;
    for (auto id : qAsConst( hiddenPlayersIds_ ))
        filterIds.append( QString::number( id )).append( ',' );

    if (!filterIds.isEmpty())
        filterIds.remove( filterIds.length() - 1, 1 );

    setFilter( QString( "id NOT IN (%1)" ).arg( filterIds ));
    emit emptyChanged( isEmpty() );
}

QVariant PlayersModel::getPhotoUrl( int playerId ) const
{
    auto photoLocation = QStandardPaths::writableLocation( QStandardPaths::AppLocalDataLocation );
    photoLocation.append( "/photo" );
    photoLocation.append( QString("/%1.png").arg( QString::number( playerId )));

    if (QFile::exists( photoLocation ))
        return QUrl::fromLocalFile( photoLocation );

    return QVariant();
}
