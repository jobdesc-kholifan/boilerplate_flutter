import 'package:flutter/material.dart';

import '../../widgets/breadcrumb.dart';

class ContentSkins extends StatelessWidget {
  const ContentSkins({
    Key? key,
    this.child,
    this.title,
    this.subTitle,
    this.breadcrumbs = const [],
  }) : super(key: key);

  final String? title;

  final String? subTitle;

  final List<BreadcrumbWidget> breadcrumbs;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        width: constraints.maxWidth,
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  this.title == null
                      ? Container()
                      : Text(
                          this.title!,
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                ],
              ),
            ),
            this.breadcrumbs.length == 0
                ? Container()
                : Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: this.breadcrumbs.map((breadcrumb) {
                        int currentIndex = this.breadcrumbs.indexOf(breadcrumb);
                        return Row(
                          children: [
                            breadcrumb,
                            currentIndex == this.breadcrumbs.length - 1
                                ? Container()
                                : Container(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Icon(
                                      Icons.keyboard_arrow_right_outlined,
                                      size: 12,
                                    ),
                                  ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
            Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
