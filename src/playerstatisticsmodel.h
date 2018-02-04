/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#ifndef PLAYERSTATISTICSMODEL_H
#define PLAYERSTATISTICSMODEL_H

#include <QSqlQueryModel>

class PlayerStatisticsModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    enum Role {
        GameDate = Qt::UserRole + 1,
        Goals
    };

    PlayerStatisticsModel( QObject* parent = nullptr );
    ~PlayerStatisticsModel() override = default;

    Q_INVOKABLE QVariant data( const QModelIndex &index, int role = Qt::DisplayRole ) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void loadPlayer( int playerId );
};

#endif // PLAYERSTATISTICSMODEL_H
