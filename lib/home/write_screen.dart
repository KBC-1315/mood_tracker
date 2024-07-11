import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mood_tracker/repo/authentification_repository.dart';
import 'package:mood_tracker/screens/widgets/form_button.dart';
import 'package:mood_tracker/view_model/upload_mood_view_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

List<String> _itemList = [
  "assets/smile_mood.json",
  "assets/angry_mood.json",
  "assets/sad_mood.json",
  "assets/annoying_mood.json"
];

class WriteScreen extends ConsumerStatefulWidget {
  final VoidCallback onUploadComplete; // Callback to notify upload completion
  const WriteScreen({super.key, required this.onUploadComplete});

  @override
  ConsumerState<WriteScreen> createState() => _WriteScreenState();
}

void _onScaffoldTap(BuildContext context) {
  FocusScope.of(context).unfocus();
}

class _WriteScreenState extends ConsumerState<WriteScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _selectedMood = 0;
  Map<String, String> formData = {};

  void _onSubmitTap(BuildContext context) async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        await ref
            .read(uploadPostProvider.notifier)
            .uploadPost(context, _itemList[_selectedMood], _controller.text);

        // Show SnackBar and navigate to home screen after it is closed

        _controller.text = "";
        FocusScope.of(context).unfocus();
        widget.onUploadComplete();
      }
    }

    @override
    void dispose() {
      _controller.dispose();
      _pageController.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(authRepo);
    final formattedDate = DateFormat('EEEE, d MMMM').format(DateTime.now());
    final nickname =
        (repo.user?.displayName != null && repo.user!.displayName!.isNotEmpty)
            ? repo.user!.displayName!
            : "user";

    final isLoading = ref.watch(uploadPostProvider).isLoading;

    return GestureDetector(
      onTap: () => _onScaffoldTap(context),
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello $nickname",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "roboto"),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "How do you feel $formattedDate",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: "roboto"),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 20,
                        ),
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 4),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.black12,
                            width: 1,
                          ),
                        ),
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: TextFormField(
                            controller: _controller,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            maxLines: 10,
                            textAlign: TextAlign.left,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your mood';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 150,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedMood = index;
                          });
                        },
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return _buildMoodCard(index);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: _itemList.length,
                        effect: const WormEffect(
                          dotHeight: 12,
                          dotWidth: 12,
                          spacing: 16,
                          activeDotColor: Colors.purple,
                          dotColor: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _onSubmitTap(context),
                      child: FormButton(
                        width: 1,
                        text: "Submit",
                        disabled: isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              ModalBarrier(
                dismissible: false,
                color: Colors.black.withOpacity(0.5),
              ),
            if (isLoading)
              Center(
                child: Lottie.asset("assets/AI_generating.json"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(int index) {
    return Card(
      color: Colors.purple[100],
      shadowColor: Colors.purple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Lottie.asset(_itemList[index], width: 100, height: 100),
      ),
    );
  }
}
