import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../profile/appbar.dart';

class CountUpTimerPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => CountUpTimerPage(),
      ),
    );
  }

  @override
  _State createState() => _State();
}

class _State extends State<CountUpTimerPage> {
  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChange: (value) => print('onChange $value'),
    onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
    onStopped: () {
      print('onStop');
    },
    onEnded: () {
      print('onEnded');
    },
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));
    _stopWatchTimer.fetchStopped
        .listen((value) => print('stopped from stream'));
    _stopWatchTimer.fetchEnded.listen((value) => print('ended from stream'));

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBar(
        showBackArrow: true,
        title: Text('Секундомер'),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /// Display stop watch time
                StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data!;
                    final displayTime =
                        StopWatchTimer.getDisplayTime(value, hours: _isHours);
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            displayTime,
                            style: const TextStyle(
                                fontSize: 40,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                /// Display every minute.
                StreamBuilder<int>(
                  stream: _stopWatchTimer.minuteTime,
                  initialData: _stopWatchTimer.minuteTime.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    print('Listen every minute. $value');
                    return const Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                /// Lap time.
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    height: 400,
                    child: StreamBuilder<List<StopWatchRecord>>(
                      stream: _stopWatchTimer.records,
                      initialData: _stopWatchTimer.records.value,
                      builder: (context, snap) {
                        final value = snap.data!;
                        if (value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        Future.delayed(const Duration(milliseconds: 100), () {
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut);
                        });
                        print('Listen records. $value');
                        return ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            final data = value[index];
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    '${index + 1} ${data.displayTime}',
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                )
                              ],
                            );
                          },
                          itemCount: value.length,
                        );
                      },
                    ),
                  ),
                ),

                /// Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilledButton(
                          onPressed: _stopWatchTimer.onStartTimer,
                          child: const Text(
                            'Start',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilledButton(
                          onPressed: _stopWatchTimer.onStopTimer,
                          child: const Text(
                            'Stop',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilledButton(
                          onPressed: _stopWatchTimer.onResetTimer,
                          child: const Text(
                            'Reset',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(0).copyWith(right: 8),
                          child: FilledButton(
                            onPressed: _stopWatchTimer.onAddLap,
                            child: const Text(
                              'Lap',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
