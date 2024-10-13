import 'package:flutter/material.dart';
import './responsive.dart';

class Header extends StatelessWidget {
  final String title;

  const Header({
    super.key,
    required this.scaffoldKey,
    required this.title,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!Responsive.isDesktop(context))
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () => scaffoldKey.currentState!.openDrawer(),
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.menu,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                //!Responsive.isMobile(context)?
                // InkWell(
                //   onTap: () => scaffoldKey.currentState!.openEndDrawer(),
                //   child: CircleAvatar(
                //     backgroundColor: Colors.transparent,
                //     child: Image.asset(
                //       "assets/images/avatar.png",
                //       width: 32,
                //     ),
                //   ),
                // ):SizedBox(),
              ],
            ),
           if (Responsive.isDesktop(context))
          //   Expanded(
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
                  Center(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
          //         InkWell(
          //           onTap: () => scaffoldKey.currentState!.openEndDrawer(),
          //           child: CircleAvatar(
          //             backgroundColor: Colors.transparent,
          //             child: Image.asset(
          //               "assets/images/avatar.png",
          //               width: 32,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
    //       if(Responsive.isDesktop(context) & !(title=="Dashboard"))
    // Align(
    //   alignment: Alignment.topRight,
    //   child: InkWell(
    //     onTap: () => scaffoldKey.currentState!.openEndDrawer(),
    //     child: CircleAvatar(
    //       backgroundColor: Colors.transparent,
    //       child: Image.asset(
    //         "assets/images/avatar.png",
    //         width: 32,
    //       ),
    //     ),
    //   ),
    // ),
          //Center(child: Text(title,style: Theme.of(context).textTheme.titleLarge,)),
          // if (!Responsive.isMobile(context))
          //   Expanded(
          //     flex: 4,
          //     child: TextField(
          //       decoration: InputDecoration(
          //           filled: true,
          //           //fillColor: cardBackgroundColor,
          //           enabledBorder: const OutlineInputBorder(
          //             borderSide: BorderSide(color: Colors.transparent),
          //           ),
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(12.0),
          //           ),
          //           focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(12.0),
          //             borderSide:
          //                 BorderSide(color: Theme.of(context).primaryColor),
          //           ),
          //           contentPadding: const EdgeInsets.symmetric(
          //             vertical: 5,
          //           ),
          //           hintText: 'Search',
          //           prefixIcon: const Icon(
          //             Icons.search,
          //             color: Colors.grey,
          //             size: 21,
          //           )),
          //     ),
          //   ),
          // if (Responsive.isMobile(context))
          //   Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
                // IconButton(
                //   icon: const Icon(
                //     Icons.search,
                //     color: Colors.grey,
                //     size: 25,
                //   ),
                //   onPressed: () {},
                // ),
            //     InkWell(
            //       onTap: () => scaffoldKey.currentState!.openEndDrawer(),
            //       child: CircleAvatar(
            //         backgroundColor: Colors.transparent,
            //         child: Image.asset(
            //           "assets/images/avatar.png",
            //           width: 32,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
        ],
      ),
    );
  }
}
