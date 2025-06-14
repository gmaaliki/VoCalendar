import 'package:flutter/material.dart';
import 'package:flutterapi/models/schedule_model.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCard({super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
          children: [
            ListTile(
                title: Text(
                  schedule.eventName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IconButton(
                      //   icon: Icon(Icons.edit, color: Colors.green),
                      //   onPressed: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return StoryEditForm(story: story);
                      //       },
                      //     );
                      //   },
                      // ),
                      // IconButton(
                      //   icon: Icon(Icons.delete, color: Colors.grey),
                      //   onPressed: () => storyVM.deleteStory(story.id ?? 0),
                      // ),
                      // IconButton(
                      //     icon: Icon(Icons.book, color: Colors.grey),
                      //     onPressed: () => Navigator.push(
                      //         context,
                      //         MaterialPageRoute(builder: (_) => StoryRead(story: story)))
                      // ),
                    ]

                )

            ),
          ],
        )
    );
  }
}