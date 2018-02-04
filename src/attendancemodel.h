/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#ifndef ATTENDANCESTATISTICSMODEL_H
#define ATTENDANCESTATISTICSMODEL_H

#include <QSqlQueryModel>

class AttendanceModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    enum Role {
        GameDate = Qt::UserRole + 1,
        PlayersCount
    };

    AttendanceModel( QObject* parent = nullptr );
    ~AttendanceModel() override = default;

    Q_INVOKABLE QVariant data( const QModelIndex &index, int role = Qt::DisplayRole ) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void reload();
};

#endif // ATTENDANCESTATISTICSMODEL_H
