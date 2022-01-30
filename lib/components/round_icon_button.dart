import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton(
      {Key? key, this.icon, required this.onPressed, this.data})
      : super(key: key);

  final IconData? icon;
  final String? data;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      child: (icon != null && data == null)
          ? Icon(icon)
          : (data != null && icon == null)
              ? Text(data!)
              : (data != null && icon != null)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          data!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(
        width: (icon == null) ? 80.0 : 56.0,
        height: (icon == null) ? 40.0 : 56.0,
      ),
      shape: (icon == null)
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            )
          : const CircleBorder(),
      fillColor: const Color(0xFF4C4F5E),
    );
  }
}
