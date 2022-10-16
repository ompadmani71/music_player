import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:music_player/uttils/global.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late AssetsAudioPlayer assetsAudioPlayer;
  bool _play = false;
  Duration totalDuration = Duration(seconds: 0);
  Duration currantDuration = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    assetsAudioPlayer = AssetsAudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    assetsAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List? index = ModalRoute.of(context)!.settings.arguments as List?;

    playAudio() async {
      assetsAudioPlayer
          .open(
        Audio(
          Global.audios[index![0]],
        ),
      )
          .then((value) {
        assetsAudioPlayer.current.listen((playingAudio) {
          setState(() {
            totalDuration = assetsAudioPlayer.current.value!.audio.duration;
          });
        });
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              dispose();
              Navigator.pop(context);
            }),
        title: Text(
          "Now Playing",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1),
              BlendMode.softLight,
            ),
            fit: BoxFit.cover,
            image: AssetImage(
              "${index![1]}",
            ),
            opacity: 0.4,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "${index[1]}",
                  ),
                  fit: BoxFit.cover,
                ),
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              Global.audioNames[index[0]],
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              Global.artists[index[0]],
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    log("hello", name: "Mini");
                    setState(() {
                      assetsAudioPlayer.stop();

                      _play = !_play;
                    });
                  },
                  icon: const Icon(Icons.stop, size: 28, color: Colors.white),
                ),
                (assetsAudioPlayer.current.hasValue)
                    ? AudioWidget.assets(
                        path: "",
                        play: false,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _play = !_play;
                              assetsAudioPlayer.playOrPause();
                            });
                          },
                          icon: (_play)
                              ? Icon(
                                  (Icons.play_arrow),
                                  color: Colors.white,
                                )
                              : Icon(
                                  (Icons.pause),
                                  color: Colors.white,
                                ),
                          alignment: Alignment.center,
                          iconSize: 45,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          playAudio();
                          setState(() {});
                        },
                        icon: Icon(
                          (Icons.play_arrow),
                          color: Colors.white,
                          size: 45,
                        ),
                        alignment: Alignment.center,
                        iconSize: 45,
                      ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.earbuds, size: 28, color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 1,
              ),
              child: StreamBuilder(
                stream: assetsAudioPlayer.currentPosition,
                builder: (context, AsyncSnapshot snapShot) {
                  Duration currentPosition = snapShot.data;

                  return Slider(
                    value: currentPosition.inSeconds.toDouble(),
                    min: 0,
                    max: totalDuration.inSeconds.toDouble(),
                    activeColor: Colors.green,
                    inactiveColor: Colors.white.withOpacity(0.8),
                    onChanged: (val) {
                      setState(() {
                        assetsAudioPlayer.seek(
                          Duration(
                            seconds: val.toInt(),
                          ),
                        );
                        currantDuration = Duration(
                          seconds: val.toInt(),
                        );
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: assetsAudioPlayer.currentPosition,
                  builder: (context, AsyncSnapshot snapShot) {
                    if (snapShot.data != null) currantDuration = snapShot.data;

                    return Text(
                      currantDuration.toString().split(".")[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    );
                  },
                ),
                Text(
                  " / ${totalDuration.toString().split(".")[0]}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
