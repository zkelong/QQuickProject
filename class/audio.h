#ifndef AUDIO_H
#define AUDIO_H

#include <QObject>
//#include <QtGui>
#include <iostream>
#include <QMediaPlayer>
#include <QAudioRecorder>
#include <QAudioEncoderSettings>

class Audio: public QObject
{
    Q_OBJECT


    enum state {
        wait,
        play,
        playpause,
        record,
        recordpause
    };

public:
    Audio();
    ~Audio(){}
//    Q_INVOKABLE void record();
//    Q_INVOKABLE void play(QString filePath);
//    Q_INVOKABLE void pause();
//    Q_INVOKABLE void stop();
//    //∑µªÿ¬º“Ùµÿ÷∑
//    Q_INVOKABLE QString getFilePath();


private:
//    QMediaPlayer * player;
//    QMediaRecorder * recorder;

signals:
//    void onDurationChanged(qint64 duration);


};

#endif // AUDIO_H
