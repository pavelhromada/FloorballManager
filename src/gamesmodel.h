/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#ifndef GAMESMODEL_H
#define GAMESMODEL_H

#include <QSqlTableModel>

class GamesModel : public QSqlTableModel
{
    Q_OBJECT
public:
    enum Role {
        Id = Qt::UserRole + 1,
        GameDate,
        GoalsTeamA,
        GoalsTeamB
    };

    GamesModel( QObject* parent = nullptr );
    ~GamesModel() override = default;

    Q_INVOKABLE QVariant data( const QModelIndex &index, int role = Qt::DisplayRole ) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // GAMESMODEL_H
