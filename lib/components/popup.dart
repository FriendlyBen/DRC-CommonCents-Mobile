import 'package:flutter/material.dart';
import 'package:commoncents/pages/changePassword.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Account Settings',
              style: Theme.of(context).textTheme.displayLarge!.merge(
                    const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
            ),
          ],
        ),
      ),
      content: Container(
        padding: const EdgeInsets.only(top: 10),
        child: const Align(
          heightFactor: 0.9,
          alignment: Alignment.centerLeft,
          child: Text(
            'Are you sure you want to change your details?',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text("Cancel")),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text("Yes")),
            ),
          ),
        ),
      ],
    );
  }
}

class LogOut extends StatelessWidget {
  const LogOut({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logout',
              style: Theme.of(context).textTheme.displayLarge!.merge(
                    const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
            ),
          ],
        ),
      ),
      content: Container(
        padding: const EdgeInsets.only(top: 10),
        child: const Align(
          heightFactor: 0.9,
          alignment: Alignment.centerLeft,
          child: Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text("Cancel")),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text("Yes")),
            ),
          ),
        ),
      ],
    );
  }
}

class Password extends StatelessWidget {
  const Password({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 300,
      child: Builder(
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            titlePadding: EdgeInsets.zero,
            title: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(11),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Align(
                      heightFactor: 0.9,
                      alignment: Alignment.center,
                      child: Text(
                        'Enter your old password to continue',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge!.merge(
                              const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            content: const TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Text("Cancel")),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePassword()),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Text("Yes")),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TradeDetails extends StatelessWidget {
  const TradeDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Trade Details',
              style: Theme.of(context).textTheme.displayLarge!.merge(
                    const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
            ),
          ],
        ),
      ),
      content: Container( 
          padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.28,
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Stake"),
                          Flexible(
                            child: Text(
                              "......................",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text("10.00 USD"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Payout"),
                          Flexible(
                            child: Text(
                              "......................",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text("N/A"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Ticks"),
                          Flexible(
                            child: Text(
                              "......................",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text("6"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Aligns "Strategy" text to the left
                        children: const [
                          Text("Strategy"),
                          Spacer(), // Adds flexible space between elements
                          Text("......................"),
                          Text("Higher"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text("Total profit/loss"),
                          Text("......................"),
                          Text("-10.00"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    color: Colors.grey[300],
                    child: const Center(child: Text("Close")),
                  ),
                )
              ],
            ),
          )),
    );
  }
}