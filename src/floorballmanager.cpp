/*
  This is free and unencumbered software released into the public domain.
  Author: pavel.hromada@gmail.com
*/

#include <random>
#include <algorithm>

#include <QCoreApplication>
#include <QQmlContext>
#include <QStandardPaths>
#include <QSqlDatabase>
#include <QDir>
#include <QFile>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDateTime>

#include "floorballmanager.h"
#include "playersmodel.h"
#include "teammodel.h"
#include "attendancemodel.h"
#include "gamesmodel.h"
#include "playerstatisticsmodel.h"
#include "teamstatisticsmodel.h"
#include "photopreviewprovider.h"

FloorballManager::FloorballManager()
{
    // handle application exit when requested from QML
    connect( &engine_, &QQmlApplicationEngine::quit,
             QCoreApplication::instance(), &QCoreApplication::quit );
}

FloorballManager::~FloorballManager() = default;

bool FloorballManager::start()
{
    if (!setupDatabase())
        return false; // TODO instead show error on GUI

    setupModels();

    engine_.addImageProvider( QStringLiteral("photo"), new PhotoPreviewProvider() );
    engine_.load( QUrl( QLatin1String( "qrc:/qml/main.qml" )));

    if (engine_.rootObjects().isEmpty())
        return false;

    return true;
}

void FloorballManager::saveMatchStatistics( int goalsTeamA, int goalsTeamB )
{
    saveMatchScore( goalsTeamA, goalsTeamB );
    auto matchId = lastAddedMatchId();
    savePlayersStatistics( matchId, *teamAModel_, 0 );
    savePlayersStatistics( matchId, *teamBModel_, 1 );

    // refresh statistics models
    attendanceModel_->reload();
    gamesModel_->select();
}

void FloorballManager::saveMatchScore( int goalsTeamA, int goalsTeamB )
{
    QSqlQuery query;
    query.prepare( "INSERT INTO "
                   "match (date, goals_team_a, goals_team_b) "
                   "VALUES (?, ?, ?)" );

    query.addBindValue( static_cast<qint32>( QDateTime::currentSecsSinceEpoch() ));
    query.addBindValue( goalsTeamA );
    query.addBindValue( goalsTeamB );
    query.exec();
}

int FloorballManager::lastAddedMatchId()
{
    QSqlQuery matchIdQuery( "SELECT seq FROM sqlite_sequence WHERE name='match'" );
    matchIdQuery.exec();
    matchIdQuery.first();
    return matchIdQuery.record().value( QStringLiteral( "seq" )).toInt();
}

int FloorballManager::lastAddedPlayerId()
{
    QSqlQuery platerIdQuery( "SELECT seq FROM sqlite_sequence WHERE name='player'" );
    platerIdQuery.exec();
    platerIdQuery.first();
    return platerIdQuery.record().value( QStringLiteral( "seq" )).toInt();
}

void FloorballManager::savePlayersStatistics( int matchId, const TeamModel& team, int teamId )
{
    QSqlQuery query;
    query.prepare( "INSERT INTO "
                   "stats (match_id, player_id, goals, team) "
                   "VALUES (:match_id, :player_id, :goals, :team)" );

    for (int i = 0; i < team.rowCount(); ++i) {
        query.bindValue( ":match_id",  matchId );
        query.bindValue( ":player_id", team.data( team.index( i, 0 ), TeamModel::Id ).toInt() );
        query.bindValue( ":goals",     team.data( team.index( i, 0 ), TeamModel::Goals ).toInt() );
        query.bindValue( ":team",      teamId );
        query.exec();
    }
}

void FloorballManager::resetSelectedPlayers()
{
    selectedPlayers_.clear();
}

void FloorballManager::selectPlayer( int id )
{
    selectedPlayers_.insert( id );
    remainingPlayersModel_->hidePlayer( id );
}

void FloorballManager::deselectPlayer( int id )
{
    selectedPlayers_.remove( id );
    remainingPlayersModel_->exposePlayer( id );
}

int FloorballManager::selectedPlayersCount() const
{
    return selectedPlayers_.size();
}

void FloorballManager::shuffleTeams()
{
    auto selectedList = selectedPlayers_.toList();
    std::random_device rd;
    std::mt19937 g( rd() );
    std::shuffle( selectedList.begin(), selectedList.end(), g );

    auto half = selectedList.begin() + (selectedList.size() / 2);

    teamAModel_->resetTeam();
    teamBModel_->resetTeam();

    for (auto it = selectedList.begin(); it < half; ++it)
        teamAModel_->addPlayer( *it );

    for (auto it = half; it < selectedList.end(); ++it)
        teamBModel_->addPlayer( *it );
}

bool FloorballManager::movePlayerToTeamB( int id )
{
    if (teamAModel_->rowCount() < 2)
        return false;

    teamAModel_->removePlayer( id );
    teamBModel_->addPlayer( id );
    return true;
}

bool FloorballManager::movePlayerToTeamA( int id )
{
    if (teamBModel_->rowCount() < 2)
        return false;

    teamBModel_->removePlayer( id );
    teamAModel_->addPlayer( id );
    return true;
}

void FloorballManager::addPlayerToTeamB( int id )
{
    remainingPlayersModel_->hidePlayer( id );
    teamBModel_->addPlayer( id );
}

void FloorballManager::addPlayerToTeamA( int id )
{
    remainingPlayersModel_->hidePlayer( id );
    teamAModel_->addPlayer( id );
}

bool FloorballManager::processPhotoPreview( const QString& url )
{
    QUrl imageUrl( url );
    auto imageProviderBase = engine_.imageProvider( imageUrl.host() );
    auto imageProvider = static_cast<QQuickImageProvider*>( imageProviderBase );

    QSize imageSize;
    QString imageId = imageUrl.path().remove( 0,1 );
    QImage image = imageProvider->requestImage( imageId, &imageSize, imageSize );

    if (image.isNull())
        return false;

    //process image
    auto cutPhoto = image.copy( image.width() / 2 - image.height() / 2,
                                0,
                                image.height(),
                                image.height() );

    auto previewProvider = static_cast<PhotoPreviewProvider*>(
                engine_.imageProvider( QStringLiteral("photo") ));

    previewProvider->updatePreview( cutPhoto );

    return true;
}

bool FloorballManager::savePhotoPreview( int playerId )
{
    auto previewProvider = static_cast<PhotoPreviewProvider*>(
                engine_.imageProvider( QStringLiteral("photo") ));

    auto photoPath = QStandardPaths::writableLocation( QStandardPaths::AppLocalDataLocation );


    if (playerId == -1)
        photoPath.append( QString("/photo/%1.png").arg( QString::number( lastAddedPlayerId() )));
    else
        photoPath.append( QString("/photo/%1.png").arg( QString::number( playerId )));

    if (!previewProvider->savePreview( photoPath ))
        return false;

    playersModel_->reload();
    remainingPlayersModel_->reload();
    return true;
}

bool FloorballManager::setupDatabase()
{
    auto dbPath = QStandardPaths::writableLocation( QStandardPaths::AppLocalDataLocation );

    if (!prepareDatabaseLocation( dbPath ))
        return false;

    qDebug( "Setting up of floorball database from directory: %s", qPrintable( dbPath ));
    dbPath.append( "/floorball.db" );

    // for the first application run, if DB does not exist => create empty one
    if (!QFile::exists( dbPath ) && !createEmptyDatabase( dbPath ))
        return false;

    return openDatabase( dbPath );
}

bool FloorballManager::prepareDatabaseLocation( const QString& dbPath )
{
    // check if storage directory location exists and create one if not
    if (dbPath.isEmpty()) {
        qDebug( "Could not obtain writable location for DB." );
        return false;
    }

    QDir storageDir{ dbPath };
    QDir photoDir{ dbPath + "/photo" };

    if (!storageDir.exists()) {
        qDebug( "Creating floorball application data location." );
        if (!storageDir.mkpath( "." )) {
            qDebug( "Could not create location %s.", qPrintable( dbPath ));
            return false;
        }
    }

    if (!photoDir.exists()) {
        qDebug( "Creating floorball application players photos location." );
        if (!photoDir.mkpath( "." )) {
            qDebug( "Could not create location %s.", qPrintable( photoDir.absolutePath() ));
            return false;
        }
    }

    return true;
}

bool FloorballManager::createEmptyDatabase( const QString& dbPath )
{
    QFile file( QStringLiteral( ":/floorball.db" ));

    if (!file.exists()) {
        qDebug( "Cannot create floorball database (not in resources)." );
        return false;
    }

    if (!file.copy( dbPath )) {
        qDebug( "Cannot create floorball database." );
        return false;
    }

    if (!QFile::setPermissions( dbPath, QFile::WriteOwner | QFile::ReadOwner)) {
        qDebug( "Cannot set read/write permissions for floorball database." );
        return false;
    }

    qDebug( "Floorball database created" );
    return true;
}

bool FloorballManager::openDatabase( const QString& dbPath )
{
    QSqlDatabase db = QSqlDatabase::addDatabase( "QSQLITE" );
    db.setDatabaseName( dbPath );

    if (!db.open()) {
        qDebug( "Cannot open floorball database." );
        return false;
    }

    qDebug( "Floorball database opened." );
    return true;
}

void FloorballManager::setupModels()
{
    playersModel_.reset( new PlayersModel );
    remainingPlayersModel_.reset( new PlayersModel );
    teamAModel_.reset( new TeamModel );
    teamBModel_.reset( new TeamModel );
    attendanceModel_.reset( new AttendanceModel );
    gamesModel_.reset( new GamesModel );
    playerStatisticsModel_.reset( new PlayerStatisticsModel );
    teamAStatisticsModel_.reset( new TeamStatisticsModel( true ));
    teamBStatisticsModel_.reset( new TeamStatisticsModel( false ));

    connect( playersModel_.get(), &PlayersModel::playerAdded,
             teamAModel_.get(), &TeamModel::resetTeam );
    connect( playersModel_.get(), &PlayersModel::playerAdded,
             teamBModel_.get(), &TeamModel::resetTeam );
    connect( playersModel_.get(), &PlayersModel::playerAdded,
             remainingPlayersModel_.get(), &PlayersModel::select );

    auto qmlContext = engine_.rootContext();

    qmlContext->setContextProperty( QStringLiteral( "remainingPlayersModel" ),
                                    remainingPlayersModel_.get() );
    qmlContext->setContextProperty( QStringLiteral( "floorballManager" ), this                   );
    qmlContext->setContextProperty( QStringLiteral( "playersModel" ),     playersModel_.get()    );
    qmlContext->setContextProperty( QStringLiteral( "teamAModel" ),       teamAModel_.get()      );
    qmlContext->setContextProperty( QStringLiteral( "teamBModel" ),       teamBModel_.get()      );
    qmlContext->setContextProperty( QStringLiteral( "attendanceModel" ),  attendanceModel_.get() );
    qmlContext->setContextProperty( QStringLiteral( "gamesModel" ),       gamesModel_.get()      );
    qmlContext->setContextProperty( QStringLiteral( "playerStatisticsModel" ),
                                    playerStatisticsModel_.get() );
    qmlContext->setContextProperty( QStringLiteral( "teamAStatisticsModel" ),
                                    teamAStatisticsModel_.get() );
    qmlContext->setContextProperty( QStringLiteral( "teamBStatisticsModel" ),
                                    teamBStatisticsModel_.get() );
}
