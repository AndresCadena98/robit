import 'dart:async';
import 'dart:ui';
import 'package:chat_gpt_api/chat_gpt.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:glowstone/glowstone.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';
import '../../../blocs/search_bloc/search_bloc.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  TextEditingController _controller = TextEditingController();

  var results = 'Results';
  //init chatGpt
  final chatGpt = ChatGPT.builder(
      token: 'YOUR_TOKEN');
  bool downloadProgress = false;
  //config chat
  List<ChatMessage> messages = [];
  late ChatUser user;
  late ChatUser otherUser;
  String? message;
  String? nameUser;
  // text to speech
  late TextToSpeech tts;
  String? textToSpeech = '';
  // Speech to text
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String lastWords = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatGpt;
    // Init user Robot
    otherUser = ChatUser(firstName: 'Robit', lastName: '', id: '2');
    user = ChatUser(
      id: '1',
      firstName: nameUser,
      profileImage: 'https://picsum.photos/200',
    );

    setInitSpeech();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechToText.initialize(
      onStatus: (status) => print('onStatus: $status'),
      onError: (errorNotification) => print('onError: $errorNotification'),
    );
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      if (result.finalResult) {
        lastWords = result.recognizedWords;
      }
    });
  }

  void _toggleMicView() {
    setState(() {
      _speechEnabled = !_speechEnabled;
    });
  }

  // Configuración del Text to Speech
  setInitSpeech() async {
    tts = TextToSpeech();
    tts.setLanguage('es-ES');

    tts.setVolume(90.0);
    tts.setPitch(1.0);
  }

  // Request generar imagen
  generateImage() async {
    var watchSearchBloc = context.watch<SearchBloc>().state;
    if (watchSearchBloc is SearchImagesState) {
      ChatMessage? message = ChatMessage(
          text: '',
          user: otherUser,
          createdAt: DateTime.now(),
          medias: [
            ChatMedia(
                url: watchSearchBloc.images!.data!.last.url!,
                fileName: 'image',
                type: MediaType.image)
          ]);

      messages.insert(0, message);
    }
  }

  // Request generar texto
  generateText() async {
    var watchSearchBloc = context.watch<SearchBloc>().state;

    if (watchSearchBloc is SearchCompletedState) {
      ChatMessage? message = ChatMessage(
        text: watchSearchBloc.completion.choices!.first.text!,
        user: otherUser,
        createdAt: DateTime.now(),
      );

      messages.insert(0, message);
      textToSpeech = watchSearchBloc.completion.choices!.first.text!.trim();
    }
  }

  // Guardar imagen UI
  downloadImage(image) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Descargar imagen'),
            content: const Text('¿Desea descargar 3la imagen?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    _save(image);
                  },
                  child: const Text('Aceptar')),
            ],
          );
        });
  }

  // Guardar imagen en galeria
  _save(image) async {
    var response = await Dio()
        .get(image, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "Image");

    print(result);

    if (results.isNotEmpty) {
      // ignore: use_build_context_synchronously
      MotionToast.success(
        toastDuration: const Duration(seconds: 5),
        title: const Text("Guardada"),
        description: const Text("La imagen se guardo correctamente"),
      ).show(context);
    } else {
      // ignore: use_build_context_synchronously
      MotionToast.error(
        toastDuration: const Duration(seconds: 5),
        title: const Text("Error"),
        description: const Text("La imagen no se pudo guardar"),
      ).show(context);
    }
  }

  // Preview de la imagen
  previewImage(image) {
    return showDialog(
        context: context,
        builder: (context) {
          return Stack(children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AlertDialog(
                elevation: 6,
                contentPadding: EdgeInsets.zero,
                actionsPadding: EdgeInsets.zero,
                shadowColor: Colors.transparent,
                content: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 0,
              child: downloadProgress
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
            ),
            Positioned(
              top: 0,
              right: 30,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: 30,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                  onPressed: () {
                    _save(image);
                  },
                  icon: const Icon(Icons.download_rounded),
                ),
              ),
            )
          ]);
        });
  }

  voicePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool('voice') ?? false
        ? tts.speak(textToSpeech!)
        : print('No hay voz');
  }

  setAvatar(BuildContext context) {
    return showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          print('hola');
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: SizedBox(
              width: double.infinity,
              child: ListView(
                children: [
                  FluttermojiCircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 100,
                  ),
                  FluttermojiCustomizer(
                      scaffoldHeight: 400,
                      theme: FluttermojiThemeData(
                          selectedIconColor: Colors.tealAccent))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var watchSearchBloc = context.watch<SearchBloc>().state;
    if (watchSearchBloc is SearchErrorState) {
      results = watchSearchBloc.message;
    } else if (watchSearchBloc is SearchCompletedState) {
      generateText();
      voicePrefs();
    } else if (watchSearchBloc is SearchImagesState) {
      generateImage();
    }
    if (watchSearchBloc is SendMessagesState) {
      messages.insert(0, watchSearchBloc.messages!);
      message = watchSearchBloc.messages!.text;
    }

    return Center(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: DashChat(
              readOnly: true,
              currentUser: user,
              typingUsers:
                  watchSearchBloc is SearchLoadingState ? [otherUser] : [],
              onSend: (ChatMessage message) {},
              messageListOptions: MessageListOptions(
                typingBuilder: (user) {
                  return Center(
                    child: Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.only(top: 20),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.tealAccent,
                      ),
                    ),
                  );
                },
                chatFooterBuilder: Visibility(
                    visible: _speechEnabled,
                    child: Glowstone(
                        radius: 100,
                        velocity: 7,
                        color: Colors.tealAccent,
                        child: Center(
                            child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(Icons.mic))))),
                separatorFrequency: SeparatorFrequency.days,
              ),
              scrollToBottomOptions: ScrollToBottomOptions(
                disabled: false,
                scrollToBottomBuilder: (scrollController) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(
                      backgroundColor: Colors.black,
                      onPressed: () {
                        scrollController.animateTo(
                          scrollController.position.minScrollExtent,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                      child: const Icon(
                        Icons.arrow_downward,
                        color: Colors.tealAccent,
                      ),
                    ),
                  );
                },
              ),
              messageOptions: MessageOptions(
                currentUserContainerColor: Colors.tealAccent,
                currentUserTextColor: Colors.black,
                containerColor: Colors.white,
                showCurrentUserAvatar: true,
                textBeforeMedia: false,
                textColor: Colors.black,
                showOtherUsersAvatar: true,
                avatarBuilder: (p0, onPressAvatar, onLongPressAvatar) {
                  /*  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.tealAccent,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setAvatar(context);
                        },
                        child: const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ); */
                  if (p0.id != '1') {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.tealAccent,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setAvatar(context);
                          },
                          child: const Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.tealAccent,
                        ),
                        child: GestureDetector(
                            onTap: () {
                              setAvatar(context);
                            },
                            child: FluttermojiCircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 100,
                            )),
                      ),
                    );
                  }
                },
                onTapMedia: (media) {
                  previewImage(media.url);
                },
              ),
              messages: messages,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Material(
                  elevation: 4,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _controller,
                    autocorrect: true,
                    autofocus: false,
                    minLines: 1,
                    maxLines: 5,
                    enableSuggestions: true,
                    enableInteractiveSelection: true,
                    expands: false,
                    keyboardType: TextInputType.text,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      hintText: 'Escribe algo...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            width: 2, color: Colors.white), //<-- SEE HERE
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  search();
                },
                icon: const Icon(Icons.send, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    ));
  }

  search() async {
    FocusManager.instance.primaryFocus?.unfocus();
    BlocProvider.of<SearchBloc>(context)
        .add(SendMessagesEvent(text: _controller.text, user: user));

    if (_controller.text.contains('imagen')) {
      Timer(const Duration(seconds: 2), () {
        BlocProvider.of<SearchBloc>(context).add(SearchImagesEvent(
          text: message!,
          chatGpt: chatGpt,
        ));
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        BlocProvider.of<SearchBloc>(context).add(SearchFullTextEvent(
            text: message!, chatGpt: chatGpt, userRobot: otherUser));
      });
    }

    _controller.clear();
  }
}
