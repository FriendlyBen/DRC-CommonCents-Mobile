import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commoncents/components/popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/appbar.dart';
import '../components/navbar.dart';
import '../cubit/candlestick_cubit.dart';
import '../cubit/isCandle_cubit.dart';
import '../cubit/login_cubit.dart';
import '../cubit/markets_cubit.dart';
import '../cubit/miniChart_cubit.dart';
import '../cubit/navbar_cubit.dart';
import '../cubit/news_tabbar_cubit.dart';
import '../cubit/numberpicker_cubit.dart';
import '../cubit/register_cubit.dart';
import '../cubit/stake_payout_cubit.dart';
import '../cubit/stock_data_cubit.dart';
import '../cubit/ticks_cubit.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  TextEditingController textController = TextEditingController();
  late List<Map<String, dynamic>> postsList = [];
  final user = FirebaseAuth.instance.currentUser;
  late bool isExpanded; // Track the expansion state
  late bool hasNewPost = true;

  Future<List<Map<String, dynamic>>> loadPosts() async {
    if (user != null) {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('posts').get();

      if (docSnapshot.docs.isEmpty) {
        print("No Posts yet");
        return postsList;
      } else {
        final postsDocs = docSnapshot.docs;

        for (final posts in postsDocs) {
          final post = posts.data();
          postsList.add(post);
        }
        return postsList;
      }
    } else {
      return postsList;
    }
  }

  @override
  void initState() {
    super.initState();
    loadPosts().then((result) {
      setState(() {
        postsList = result;
      });
    });
    isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    print(user!.email);
    print("Here: ${user!.displayName}");
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        toolbarHeight: 60,
        backgroundColor: const Color(0XFF3366FF),
        title: const Text(
          "Forum",
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: postsList.isNotEmpty
          ? Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.all(5),
                    //   height: MediaQuery.of(context).size.height * 0.1,
                    //   width: MediaQuery.of(context).size.width * 0.95,
                    //   decoration: BoxDecoration(
                    //       color: Colors.grey[400],
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: Row(
                    //     children: [
                    //       CircleAvatar(
                    //         backgroundImage: NetworkImage(
                    //           user!.photoURL ??
                    //               'https://static01.nyt.com/newsgraphics/2019/08/01/candidate-pages/3b31eab6a3fd70444f76f133924ae4317567b2b5/trump-circle.png',
                    //         ),
                    //         radius: 40,
                    //       ),
                    //       Container(
                    //         color: Colors.white,
                    //         height: MediaQuery.of(context).size.height * 0.05,
                    //         width: MediaQuery.of(context).size.width * 0.7,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: postsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final post = postsList[index];
                            return Container(
                              margin: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: const EdgeInsets.all(10),
                              // height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black26)),
                              child: Column(
                                children: [
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              post['authorImage'] ??
                                                  'https://static01.nyt.com/newsgraphics/2019/08/01/candidate-pages/3b31eab6a3fd70444f76f133924ae4317567b2b5/trump-circle.png',
                                            ),
                                            radius: 40,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.63,
                                                padding:
                                                    const EdgeInsets.all(1),
                                                child: Text(
                                                  post['author'],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.63,
                                                padding:
                                                    const EdgeInsets.all(1),
                                                child: Text(
                                                  post['details'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context) {
                print("Here: ${user!.displayName}");
                return PostSomething();
              });
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
          if (hasNewPost)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(index: 3),
    );
  }
}

// Column(
//   children: [
//     const SizedBox(height: 10),
//     Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(5),
//           height: MediaQuery.of(context).size.height * 0.1,
//           width: MediaQuery.of(context).size.width * 0.95,
//           decoration: BoxDecoration(
//               color: Colors.grey[400],
//               borderRadius: BorderRadius.circular(10)),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundImage: NetworkImage(
//                   user!.photoURL ??
//                       'https://static01.nyt.com/newsgraphics/2019/08/01/candidate-pages/3b31eab6a3fd70444f76f133924ae4317567b2b5/trump-circle.png',
//                 ),
//                 radius: 40, // Adjust the radius as needed
//               ),
//               Container(
//                 color: Colors.white,
//                 height: MediaQuery.of(context).size.height * 0.05,
//                 width: MediaQuery.of(context).size.width * 0.7,
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//     Expanded(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: postsList.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final post = postsList[index];
//                 return Container(
//                   margin: const EdgeInsets.all(10),
//                   width: MediaQuery.of(context).size.width * 0.5,
//                   height: MediaQuery.of(context).size.height * 0.15,
//                   color: Colors.red,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     ),
//   ],
// ),
