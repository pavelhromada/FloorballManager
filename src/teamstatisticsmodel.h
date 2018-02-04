/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#ifndef TEAMSTATISTICSMODEL_H
#define TEAMSTATISTICSMODEL_H

#include <QSqlQueryModel>

class TeamStatisticsModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    enum Role {
        Goals = Qt::UserRole + 1,
        GameDate,
        FirstName,
        LastName
    };

    TeamStatisticsModel( bool teamA, QObject* parent = nullptr );
    ~TeamStatisticsModel() override = default;

    Q_INVOKABLE QVariant data( const QModelIndex &index, int role = Qt::DisplayRole ) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void loadMatch( int matchId );

private:
    bool teamA_ = true;
};

#endif // TEAMSTATISTICSMODEL_H
