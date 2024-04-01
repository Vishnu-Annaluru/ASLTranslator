import 'package:flutter/material.dart';

class BrailleHome extends StatefulWidget {
  BrailleHome({Key? key}) : super(key: key);

  @override
  _BrailleHomeState createState() => _BrailleHomeState();
}

class _BrailleHomeState extends State<BrailleHome> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                width: 10,
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 47, 47, 48),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _textController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Text",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _textController.clear();
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
