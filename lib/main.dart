import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:myproject1/splash_screen.dart';
import 'package:radio_player/radio_player.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ));

class RadioApp extends StatefulWidget {
  @override
  _RadioAppState createState() => _RadioAppState();
}

class _RadioAppState extends State<RadioApp> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initRadioPlayer();


    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.playing) {
        setState(() {
          isPlaying = true;
          isLoading = playerState.processingState == ProcessingState.loading ||
              playerState.processingState == ProcessingState.buffering;
        });
      } else {
        setState(() {
          isPlaying = false;
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initRadioPlayer() async {
    _radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });

    // Set the channel details
  }

  Future<void> togglePlayPause() async {
    String url2 = 'http://10.0.26.2:8000/UOW'; // First URL
    String url1 = 'http://111.68.98.216:8000/UOW'; // Second URL

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showPopupMessage('No internet connection found.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    if (isPlaying) {
      // Pause both players
      await _audioPlayer.pause();
      await _radioPlayer.pause();
    } else {
      bool played = false;

      // Try to play with AudioPlayer and RadioPlayer in sync
      try {
        await _audioPlayer.setUrl(url1);
        await _radioPlayer.setChannel(
            title: 'University of Wah \n  FM Radio-101.8',
            url: url1,
            imagePath: 'assets/images/uow_logo.png');
        _radioPlayer.play();
        await _audioPlayer.play();

        played = true;
      } catch (e) {
        print("Error playing first URL: $e");
      }

      if (!played) {
        try {
          await _audioPlayer.setUrl(url2);
          await _radioPlayer.setChannel(
              title: 'University of Wah \n  FM Radio-101.8',
              url: url2,
              imagePath: 'assets/images/uow_logo.png');
          _radioPlayer.play();
          await _audioPlayer.play();

          played = true;
        } catch (e) {
          print("Error playing second URL: $e");
        }
      }

      if (!played) {
        _showPopupMessage('The station is not available.');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showPopupMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 285,
            child: DrawerHeader(
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/uow_logo.png',
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      'assets/images/live_radio_logo.png',
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: ListTile(
              tileColor: Colors.black12,
              leading: Icon(
                Icons.mic,
                color: Colors.blue,
              ),
              title: Text(
                'Listen Live',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.radio),
            title: Text('Programs'),
            onTap: () {
              _showPopupMessage("This feature will come soon.");
            },
          ),
          ListTile(
            leading: Icon(Icons.note_add),
            title: Text('Top Stories'),
            onTap: () {
              _showPopupMessage("This feature will come soon.");
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              _showPopupMessage("This feature will come soon.");
            },
          ),
          ListTile(
            leading: Icon(Icons.chat_bubble_outline),
            title: Text('Your Feedback'),
            onTap: () {
              _showPopupMessage("This feature will come soon.");
            },
          ),
          Divider(
            color: Colors.black12,
            thickness: 0.5,
          ),
          ListTile(
            title: Text('Communicate'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () {
              _showPopupMessage("This feature will come soon.");
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Listen Live')),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          Column(
            children: [

                // Image container
              Stack(
                children: [
                  // Image container
                  Container(
                    width: double.infinity,

                    child: Image.asset(
                      'assets/images/finalpx.PNG',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Positioned Row at the top of the image
                  Positioned(
                    top: 220, // Adjust this value to position the row relative to the top of the image
                    left: 0, // Start from the left edge
                    right: 0, // Extend to the right edge
                    child: Container(
                      height: 70,
                      color: Colors.white10.withOpacity(0.3), // Light background color with opacity
                      padding: EdgeInsets.symmetric(horizontal: 10), // Padding on the sides
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start, // Center horizontally
                        children: [
                          isLoading
                              ? CircularProgressIndicator()
                              :   IconButton(
                            icon: Image.asset(
                              isPlaying
                                  ? 'assets/images/stop_new.png'
                                  : 'assets/images/play_new.png',
                              width: 64.0, // Set the width of the image
                              height: 64.0, // Set the height of the image
                            ),
                            onPressed: togglePlayPause,
                            iconSize: 64.0,
                            color: Colors.white, // Optional: Color for the icon
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
              ,

                // Positioned Row at the bottom of the image


              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text(
                      'LOCATION:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Wah Cantt, Pakistan'),
                    SizedBox(height: 20),
                    Text(
                      'GENRE:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Education, Community Development, Social Service'),
                    SizedBox(height: 30),
                    Text(
                      'DESCRIPTION:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'University of Wah - FM 101.8 is an educational radio '
                      'of University of Wah. The channel offers educational, '
                      'community development, and social service programs '
                      'for Wah and adjoining populace.',
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/home_icon.png'), // Replace with your home icon image
                          iconSize: 40.0, // Adjust size accordingly
                          onPressed: () {
                            // Add functionality for home button here
                          },
                        ),
                        SizedBox(width: 10), // Adjust spacing between icons
                        IconButton(
                          icon: Image.asset('assets/images/facebook_icon.png'), // Replace with your Facebook icon image
                          iconSize: 40.0, // Adjust size accordingly
                          onPressed: () {
                            // Add functionality for Facebook button here
                          },
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Image.asset('assets/images/share_icon.png'), // Replace with your share icon image
                          iconSize: 40.0, // Adjust size accordingly
                          onPressed: () {
                            // Add functionality for share button here
                          },
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Image.asset('assets/images/website_icon.png'), // Replace with your web icon image
                          iconSize: 40.0, // Adjust size accordingly
                          onPressed: () {
                            // Add functionality for web button here
                          },
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
               // Adjust height to your preference
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/background_image.png'), // Add your background image here
                  fit: BoxFit.cover,
                ),

                  border: Border(
                    top: BorderSide(
                      color: Colors.black45,// Color of the top border
                      width: 5.0, // Thickness of the top border
                    ),
                  )

              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Ensures spacing between logo, text, and buttons
                children: [
                  // Left side logo
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/uow_logo.png', // Add your logo here
                        width: 50.0, // Adjust the size of the logo
                        height: 50.0,
                      ),
                      SizedBox(
                          width:
                              10), // Add some space between the logo and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'University of Wah - FM Radio 101.8',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            'Listen Live',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Right side play/pause button
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: togglePlayPause,
                    iconSize: 32.0, // Adjust the size of the icon
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
