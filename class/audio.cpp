#include "audio.h"
#include "qkit.h"
#include <QCoreApplication>
#include <QDateTime>
#include <QFile>
#include <QDir>
#include <QDebug>

Audio::Audio()
{}

Audio::~Audio()
{}

/**
 * @brief 播放
 * @param filePath  文件路径
 */
void Audio::play(QString filePath)
{
    checkPlayInitial();
    m_player->setMedia(QUrl(filePath));
    m_player->play();
}

/**
 * @brief 暂停
 */
void Audio::playPause()
{
    checkPlayInitial();
    m_player->pause();
}

/**
 * @brief 停止
 */
void Audio::playStop()
{
    checkPlayInitial();
    m_player->stop();
}

/**
 * @brief 跳到指定位置
 * @param position
 */
void Audio::seek(qint64 position)
{
    checkPlayInitial();
    m_player->setPosition(position);
}

/**
 * @brief 录音
 */
void Audio::record()
{
    checkRecordInitial();
    QString path = QKit::instance()->runTimeCachePath();
    qDebug()<<"start AudioRecord";
    //inputs
    m_recorder->setOutputLocation(QUrl::fromLocalFile(m_filePath));
    m_filePath = QString("%1/%2.%3")
            .arg(path)
            .arg(QDateTime::currentDateTime().toString("yyyyMMddhhmmss"))
            .arg(m_container);
    qDebug()<<"currentPath: "<< QDir::currentPath();
    qDebug()<<"m_filePath: "<< m_filePath;
    m_recorder->setOutputLocation(QUrl::fromLocalFile(m_filePath));
    m_recorder->record();
}

/**
 * @brief 录音暂停
 */
void Audio::recordPause()
{
    checkRecordInitial();
    m_recorder->pause();
}

/**
 * @brief 停止录音
 */
void Audio::recordStop()
{
    checkRecordInitial();
    m_recorder->stop();
    QFile::setPermissions(m_filePath, QFile::ReadOwner | QFile::ReadOther | QFile::ReadUser | QFile::ReadGroup);
}

/**
 * @brief 返回录音路径
 * @return
 */
QString Audio::getFilePath()
{
    return m_filePath;
}

/**
 * @brief 检查 m_player 是否初始化，未初始化，则创建
 */
void Audio::checkPlayInitial()
{
    if(NULL == m_player)
    {
        m_player = new QMediaPlayer(this);  //智能指针，不用手动delete
        connect(m_player, SIGNAL(stateChanged(QMediaPlayer::State)),
                this, SIGNAL(playStateChanged(QMediaPlayer::State)));
        connect(m_player, SIGNAL(error(QMediaPlayer::Error)),
                this, SIGNAL(playErrored(QMediaPlayer::Error)));
        connect(m_player, SIGNAL(durationChanged(qint64)),
                this, SIGNAL(playDurationChanged(qint64)));
        connect(m_player, SIGNAL(positionChanged(qint64)),
                this, SIGNAL(playPositionChanged(qint64)));
    }
}

/**
 * @brief 检查 m_recorder 是否初始化，未初始化，则创建
 */
void Audio::checkRecordInitial()
{
    if(NULL == m_recorder)
    {
        m_recorder = new QAudioRecorder(this);  //智能指针，不用手动delete
        connect(m_recorder, SIGNAL(stateChanged(QAudioRecorder::State)),
                this, SIGNAL(recordStateChanged(QAudioRecorder::State)));
        connect(m_recorder, SIGNAL(error(QAudioRecorder::Error)),
                this, SIGNAL(recordErrored(QAudioRecorder::Error)));
        connect(m_recorder, SIGNAL(durationChanged(qint64)),
                this, SIGNAL(recordDurationChanged(qint64)));
        recordSetting();
    }
}

void Audio::recordSetting()
{
    QStringList inputs = m_recorder->audioInputs();
    if(inputs.size() == 0){ //音频输入列表，设备列表？
        return;
    }
    m_recorder->setAudioInput("default");   //默认的音频输入
    //codecs
    QStringList codecs = m_recorder->supportedAudioCodecs(); //父类QMediaPlayer的方法，返回 支持的音频编解码器 列表
    if(codecs.size() == 0){
        return;
    }
    int sampleRate = 8000;  //采样率
    if(codecs.contains("aac")){
        m_recorderSettings.setCodec("aac");
    }else if(codecs.contains("amr-nb")){
        m_recorderSettings.setCodec("amr-nb");
    }else if(codecs.contains("amr-wb")){
        m_recorderSettings.setCodec("amr-wb");
    }else{
        m_recorderSettings.setCodec(codecs.at(0));
    }
    //containers
    QStringList containers = m_recorder->supportedContainers(); //返回支持的容器格式的列表。
    if(containers.size() == 0){
        return;
    }
    if(containers.contains("3gp")){
        m_container="3gp";
    }else if(containers.contains("mp4")){
        m_container="mp4";
    }else{
        //container=containers.at(0);
        m_container="wav";
    }
    //sample rate
    QList<int> sampleRates= m_recorder->supportedAudioSampleRates();//返回支持的音频采样率的列表。
    if(sampleRates.size() == 0){
        return;
    }
    qDebug()<<"sampleRates: "<< sampleRates;
    if(sampleRates.size() && !sampleRates.contains(sampleRate)){
        sampleRate = sampleRates.at(0);
    }
    qDebug()<<"sampleRate: "<< sampleRate;
    m_recorderSettings.setChannelCount(1);
    m_recorderSettings.setSampleRate(sampleRate);
    m_recorderSettings.setQuality(QMultimedia::NormalQuality);
    m_recorderSettings.setBitRate(16000);
    m_recorderSettings.setEncodingMode(QMultimedia::AverageBitRateEncoding);
    m_recorder->setEncodingSettings(m_recorderSettings,
                                   QVideoEncoderSettings(),
                                   m_container
                                   );
}

