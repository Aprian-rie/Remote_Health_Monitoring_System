import 'package:flutter/material.dart';
import '../defaults/vital_signs_container.dart';

class HomeTab extends StatelessWidget {
  final bool isLoading;
  final Animation<double> tempAnimation;
  final Animation<double> bpmAnimation;
  final Animation<double> o2Animation;
  final Animation<double> bloodpressureAnimation;

  const HomeTab({
    Key? key,
    required this.isLoading,
    required this.tempAnimation,
    required this.bpmAnimation,
    required this.o2Animation,
    required this.bloodpressureAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: Text(
              'Loading....',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InfoContainer(
                      title: 'Temperature',
                      value: '${tempAnimation.value.toInt()}',
                      unit: '°C',
                      containerColor: Color(0xfffbecf0),
                      textColor: Color(0xFFD2416E),
                    ),
                    InfoContainer(
                      title: 'Oxygen Conc',
                      value: '${o2Animation.value.toInt()}',
                      unit: '%',
                      containerColor: Color(0xffe7f7f7),
                      textColor: Color(0xff0DB1AD),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InfoContainer(
                      title: 'Blood Pressure',
                      value: '${bloodpressureAnimation.value.toInt()}',
                      unit: 'mm/Hg',
                      containerColor: Color(0xffe8f2fb),
                      textColor: Color(0xFF197BD2),
                    ),
                    InfoContainer(
                      title: 'Heart Rate',
                      value: '${bpmAnimation.value.toInt()}',
                      unit: 'BPM',
                      containerColor: Color(0xfff1ecfa),
                      textColor: Color(0xff7042C9),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
