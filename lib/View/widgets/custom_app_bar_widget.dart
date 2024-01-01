import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final void Function() onTap;
  final String date;
  final Color color;

  CustomAppBarWidget({
    Key? key,
    required this.onTap,
    required this.date,
    required this.color,
  }) : super(key: key);

  @override
  State<CustomAppBarWidget> createState() => _CustomAppBarWidgetState();

  @override
  Size get preferredSize => const Size(double.infinity, 110.0);
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: widget.preferredSize.height,
      color: widget.color,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 10.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              borderRadius: BorderRadius.circular(20.0),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 18.0, right: 8.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.date,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(20.0),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}