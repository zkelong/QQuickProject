#include "audiorecord.h"
#include "qkit.h"
#include <QDebug>
#include <QDateTime>
#include <QFile>
QAudioRecord::QAudioRecord()
{
    qDebug()<<"recorder init";
    setupAudioRecorder();
    setupAudioPlayer();
}

void QAudioRecord::setupAudioRecorder(){
    QStringList inputs = m_recorder.audioInputs();
    if(inputs.size() == 0){
        qDebug()<<"inputs.size() ==0";
        return;
    }
    qDebug()<<"inputs: "<< inputs;
    m_recorder.setAudioInput("default");
    //codecs
    QStringList codecs = m_recorder.supportedAudioCodecs();
    if(codecs.size() == 0){
        qDebug()<<"codecs.size() ==0";
        return;
    }
    qDebug()<<"codecs: "<< codecs;
    int sampleRate = 8000;
    if(codecs.contains("aac")){
        m_settings.setCodec("aac");
    }else if(codecs.contains("amr-nb")){
        m_settings.setCodec("amr-nb");
    }else if(codecs.contains("amr-wb")){
        m_settings.setCodec("amr-wb");
    }else{
        m_settings.setCodec(codecs.at(0));
    }

    qDebug()<<"set Codec: "<< m_settings.codec();
    //containers
    QStringList containers = m_recorder.supportedContainers();
    if(containers.size() == 0){
        qDebug()<<"containers.size() ==0";
        return;
    }
    qDebug()<<"containers: "<< containers;
    if(containers.contains("3gp")){
        container="3gp";
    }else if(containers.contains("mp4")){
        container="mp4";
    }else{
        //container=containers.at(0);
        container="wav";
    }

    qDebug()<<"container: "<< container;
    //sample rate
    QList<int> sampleRates= m_recorder.supportedAudioSampleRates();
    if(sampleRates.size() == 0){
        qDebug()<<"sampleRates.size() ==0";
        return;
    }

    qDebug()<<"sampleRates: "<< sampleRates;
    if(sampleRates.size() && !sampleRates.contains(sampleRate)){
        sampleRate = sampleRates.at(0);
    }
    qDebug()<<"sampleRate: "<< sampleRate;
    m_settings.setChannelCount(1);
    m_settings.setSampleRate(sampleRate);
    m_settings.setQuality(QMultimedia::NormalQuality);
    m_settings.setBitRate(16000);
    m_settings.setEncodingMode(QMultimedia::AverageBitRateEncoding);
    m_recorder.setEncodingSettings(m_settings,
                                   QVideoEncoderSettings(),
                                   container
                                   );
    connect(&m_recorder,SIGNAL(durationChanged(qint64)),this,
            SLOT(onRecordDurationChanged(qint64)));
    connect(&m_recorder,SIGNAL(statusChanged(QMediaRecorder::Status)),this,
            SLOT(onRecordStatusChanged(QMediaRecorder::Status)));
    connect(&m_recorder,SIGNAL(error(QMediaRecorder::Error)),this,
            SLOT(onRecordError(QMediaRecorder::Error)));
}
void QAudioRecord::setupAudioPlayer(){
    m_player = new QMediaPlayer(this);
    connect(m_player,SIGNAL(positionChanged(qint64)),this,
            SLOT(onPlayPositionChanged(qint64)));
    connect(m_player,SIGNAL(stateChanged(QMediaPlayer::State)),this,
            SLOT(onPlayStateChanged(QMediaPlayer::State)));
    connect(m_player,SIGNAL(error(QMediaPlayer::Error)),this,
            SLOT(onPlayError(QMediaPlayer::Error)));
    connect(m_player,SIGNAL(durationChanged(qint64)),this,
            SLOT(onPlayDurationChanged(qint64)));
}

QString QAudioRecord::getFilePath(){
    return m_filePath;
}
void QAudioRecord::onRecordDurationChanged(qint64 duration){

    durationChanged(duration);
}
void QAudioRecord::onRecordError(QMediaRecorder::Error err){
    qDebug()<<"Record Error --- " << err;
    m_recorder.stop();
    isRecorder=false;
    error(1);
}
void QAudioRecord::onRecordStatusChanged(QMediaRecorder::Status status){
    qDebug()<<"Record Status --- " << status;
    int statusValue=0;
    switch (status) {
    case QMediaRecorder::StartingStatus:
        statusValue=1;
        break;

    case QMediaRecorder::UnloadedStatus:
        statusValue=2;
        break;

    case QMediaRecorder::FinalizingStatus:
        statusValue=2;
        break;
    default:
        return;
    }
    statusChanged(statusValue);
}
void QAudioRecord::recorder()
{
    QString path = QKit::instance()->runTimeCachePath();
    if(isPlayer){
        qDebug()<<"正在播放不能录音";
        return;
    }
    if(!isRecorder){
        qDebug()<<"start AudioRecord";
        //inputs
        m_recorder.setOutputLocation(QUrl::fromLocalFile(m_filePath));
        m_filePath = QString("%1/%2.%3")
                .arg(path)
                .arg(QDateTime::currentDateTime().toString("yyyyMMddhhmmss"))
                .arg(container);
        qDebug()<<"currentPath: "<<QDir::currentPath();
        qDebug()<<"m_filePath: "<<m_filePath;
        m_recorder.setOutputLocation(QUrl::fromLocalFile(m_filePath));
        m_recorder.record();
        isRecorder=true;
    }else{
        qDebug()<<"stop AudioRecord";
        m_recorder.stop();
        QFile::setPermissions(m_filePath,QFile::ReadOwner | QFile::ReadOther | QFile::ReadUser | QFile::ReadGroup);
        isRecorder=false;
        qDebug()<<"--- m_recorder.duration --- " << m_recorder.duration();
    }
}

void QAudioRecord::play(QString filePath)
{
    if(isRecorder){
        qDebug()<<"正在录音不能播放";
        return;
    }
    if(!isPlayer){
        qDebug()<<"player";
        qDebug()<<"filePath"<<filePath;
        m_player->setMedia(QUrl(filePath));
        m_player->play();
        isPlayer=true;
    }else{
        m_player->stop();
        isPlayer=false;
    }
}
void QAudioRecord::onPlayPositionChanged(qint64 position){
    positionChanged(position);
}
void QAudioRecord::onPlayDurationChanged(qint64 duration){
    if(duration!=0){
        durationChanged(duration);
    }
}

void QAudioRecord::onPlayError(QMediaPlayer::Error err){
    qDebug()<<"Play Error --- " << err;
    m_player->stop();
    isPlayer=false;
    error(2);
}
void QAudioRecord::onPlayStateChanged(QMediaPlayer::State state){
    qDebug()<<"Play State --- " << state;
    int statusValue=0;
    switch (state) {
    case QMediaPlayer::PlayingState:
        statusValue=3;
        break;
    case QMediaPlayer::PausedState:
        statusValue=4;
        isPlayer=false;
        break;
    case QMediaPlayer::StoppedState:
        statusValue=4;
        isPlayer=false;
        break;
    default:
        return;
    }
    statusChanged(statusValue);
}
