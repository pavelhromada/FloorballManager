/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#ifndef FLOORBALLMANAGER_H
#define FLOORBALLMANAGER_H

#include <memory>
#include <QQmlApplicationEngine>
#include <QSet>

class PlayersModel;
class TeamModel;
class AttendanceModel;
class GamesModel;
class PlayerStatisticsModel;
class TeamStatisticsModel;

class FloorballManager : public QObject
{
    Q_OBJECT
public:
    FloorballManager();
    ~FloorballManager();

    bool start();

    Q_INVOKABLE void saveMatchStatistics( int goalsTeamA, int goalsTeamB );

    Q_INVOKABLE void resetSelectedPlayers();
    Q_INVOKABLE void selectPlayer( int id );
    Q_INVOKABLE void deselectPlayer( int id );
    Q_INVOKABLE int selectedPlayersCount() const;
    Q_INVOKABLE void shuffleTeams();

    Q_INVOKABLE bool movePlayerToTeamB( int id );
    Q_INVOKABLE bool movePlayerToTeamA( int id );

    Q_INVOKABLE void addPlayerToTeamB( int id );
    Q_INVOKABLE void addPlayerToTeamA( int id );

    Q_INVOKABLE bool processPhotoPreview( const QString& url );
    Q_INVOKABLE bool savePhotoPreview( int playerId );

private:
    bool setupDatabase();
    bool prepareDatabaseLocation( const QString& dbPath );
    bool createEmptyDatabase( const QString& dbPath );
    bool openDatabase( const QString& dbPath );
    void setupModels();
    void saveMatchScore( int goalsTeamA, int goalsTeamB );
    int lastAddedMatchId();
    int lastAddedPlayerId();
    void savePlayersStatistics( int matchId, const TeamModel& team , int teamId );

    QQmlApplicationEngine                   engine_;
    std::unique_ptr<PlayersModel>           playersModel_;
    std::unique_ptr<PlayersModel>           remainingPlayersModel_;
    std::unique_ptr<TeamModel>              teamAModel_;
    std::unique_ptr<TeamModel>              teamBModel_;
    std::unique_ptr<AttendanceModel>        attendanceModel_;
    std::unique_ptr<GamesModel>             gamesModel_;
    std::unique_ptr<PlayerStatisticsModel>  playerStatisticsModel_;
    std::unique_ptr<TeamStatisticsModel>    teamAStatisticsModel_;
    std::unique_ptr<TeamStatisticsModel>    teamBStatisticsModel_;
    QSet<int>                               selectedPlayers_;
};

#endif // FLOORBALLMANAGER_H
