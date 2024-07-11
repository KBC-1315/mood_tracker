import 'package:flutter/material.dart';
import 'package:mood_tracker/constants/sizes.dart';

class FormButton extends StatelessWidget {
  const FormButton(
      {super.key,
      required this.disabled,
      required this.text,
      required this.width});
  final bool disabled;
  final String text;
  final double width;
  @override
  Widget build(BuildContext context) {
    return (width == 1)
        ? FractionallySizedBox(
            widthFactor: width,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.size5),
                color: disabled
                    ? Colors.grey.shade300
                    : Theme.of(context).primaryColor,
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: disabled ? Colors.grey.shade300 : Colors.white,
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        : SizedBox(
            width: MediaQuery.of(context).size.width * width,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.size5),
                color: disabled
                    ? Colors.grey.shade300
                    : Theme.of(context).primaryColor,
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: disabled ? Colors.grey.shade300 : Colors.white,
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
  }
}
