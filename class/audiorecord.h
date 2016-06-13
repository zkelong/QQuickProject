#ifndef AUDIORECORD_H
#define AUDIORECORD_H
#include <QtGui>
#include <QObject>
#include <iostream>
#include <QMediaPlayer>
#include <QAudioRecorder>
#include <QAudioEncoderSettings>

class QAudioRecord: public QObject
{
    Q_OBJECT
public:
    QAudioRecord();
    Q_INVOKABLE void recorder();
    Q_INVOKABLE void play(QString filePath);
    //返回录音地址
    Q_INVOKABLE QString getFilePath();
    //返回音乐时长
//    Q_INVOKABLE qint64 getDuration();
    bool isRecorder=false;
    bool isPlayer=false;
private:
      QAudioRecorder m_recorder;
      QAudioEncoderSettings m_settings;
      QMediaPlayer *m_player;
      QString m_filePath;
      QString container;
      void setupAudioRecorder();
      void setupAudioPlayer();
//      qint64 p_duration;
signals:
      void durationChanged(qint64 duration);
      void statusChanged(qint64 status);
      void error(qint64 err);
      void positionChanged(qint64 position);
protected slots:
      //录音时间变化
      void onRecordDurationChanged(qint64 duration);
      //录音出错
      void onRecordError(QMediaRecorder::Error);
      //录音状态改变
      void onRecordStatusChanged(QMediaRecorder::Status);
      //播放时间变化
      void onPlayPositionChanged(qint64 position);
      //语音时长变化
      void onPlayDurationChanged(qint64 duration);
      //播放出错
      void onPlayError(QMediaPlayer::Error);
      //播放状态改变
      void onPlayStateChanged(QMediaPlayer::State);
};

#endif // AUDIORECORD_H
