#ifndef AUDIO_H
#define AUDIO_H

#include <QObject>
//#include <QtGui>
#include <iostream>
#include <QMediaPlayer>
#include <QAudioRecorder>
#include <QAudioEncoderSettings>

class Audio : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString filePath READ getFilePath)

public:
    Audio();
    ~Audio();
    //²¥·Å
    Q_INVOKABLE void play(QString filePath);
    Q_INVOKABLE void playPause();
    Q_INVOKABLE void playStop();
    Q_INVOKABLE void seek(qint64 position);
    //Â¼Òô
    Q_INVOKABLE void record();
    Q_INVOKABLE void recordPause();
    Q_INVOKABLE void recordStop();

    QString getFilePath();

private:
    void checkPlayInitial();
    void checkRecordInitial();
    void recordSetting();
    QMediaPlayer *m_player;
    QAudioRecorder *m_recorder;
    QAudioEncoderSettings m_recorderSettings;
    QString m_container;
    QString m_filePath;


signals:
    //²¥·Å
    void playStateChanged(QMediaPlayer::State state);
    void playErrored(QMediaPlayer::Error error);
    void playDurationChanged(qint64 duration);
    void playPositionChanged(qint64 position);
    //Â¼Òô
    void recordStateChanged(QAudioRecorder::State state);
    void recordErrored(QAudioRecorder::Error error);
    void recordDurationChanged(qint64 duration);
};

#endif // AUDIO_H
