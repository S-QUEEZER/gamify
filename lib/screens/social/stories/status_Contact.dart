// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:halenest/models/status_model.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/status_methods.dart';
import 'package:halenest/screens/social/stories/stories.dart';
import 'package:halenest/util/colors.dart';

import 'package:provider/provider.dart';

class StatusContactsScreen extends StatefulWidget {
  const StatusContactsScreen({Key? key}) : super(key: key);

  @override
  State<StatusContactsScreen> createState() => _StatusContactsScreenState();
}

class _StatusContactsScreenState extends State<StatusContactsScreen> {
  Future<List<Status>> getStatus(
    BuildContext context,
  ) async {
    List<Status> statuses = await StatusRepository(
            auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance)
        .getStatus(
      context,
    );
    return statuses;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return FutureBuilder<List<Status>>(
      future: getStatus(
        context,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return StatusScreen(status: statusData);
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        statusData.username,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          statusData.profilePic,
                        ),
                        radius: 30,
                      ),
                    ),
                  ),
                ),
                const Divider(color: dividerColor, indent: 85),
              ],
            );
          },
        );
      },
    );
  }
}
