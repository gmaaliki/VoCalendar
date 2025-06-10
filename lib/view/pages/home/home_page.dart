import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapi/models/tasks.model.dart';
import 'package:flutterapi/providers/user_provider.dart';
import 'package:flutterapi/services/database/tasks_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> _upcomingTasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUpcomingTasks();
  }

  void _fetchUpcomingTasks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          _upcomingTasks = [];
          _loading = false;
        });
      }
      return;
    }
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    TasksService().getTasksForUser(user.uid).listen((tasks) {
      try {
        final upcoming = tasks
            .where((t) =>
                !t.completed &&
                t.dueDate.toDate().isAfter(todayStart.subtract(const Duration(seconds: 1))))
            .toList();
        upcoming.sort((a, b) => a.dueDate.toDate().compareTo(b.dueDate.toDate()));
        if (mounted) {
          setState(() {
            _upcomingTasks = upcoming;
            _loading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _upcomingTasks = [];
            _loading = false;
          });
        }
      }
    }, onError: (e) {
      if (mounted) {
        setState(() {
          _upcomingTasks = [];
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).userData;
    final nextEvent = _upcomingTasks.isNotEmpty ? _upcomingTasks.first : null;
    final restEvents = _upcomingTasks.length > 1 ? _upcomingTasks.sublist(1) : [];
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Greeting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, Welcome',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        userData['name'] ?? 'No Name',
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFBDF152),
                        ),
                      ),
                    ],
                  ),

                  // Profile picture
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.white,
                    // backgroundImage: const AssetImage(
                    //   'assets/images/apple.png',
                    // ),
                    child: Icon(Icons.person, size: 40.sp, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Upcoming event card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [const Color(0xFFBDF152), const Color(0xFF3F24E6)],
                  ),
                ),
                child: nextEvent == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your next event',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text('No upcoming events', style: TextStyle(color: Colors.black, fontSize: 18.sp)),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your next event',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Icon(
                                Icons.event_rounded,
                                size: 24.sp,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  nextEvent.title,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_filled,
                                size: 24.sp,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                _formatEventTime(nextEvent.dueDate),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
              SizedBox(height: 30.h),

              // Upcoming events section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'UPCOMING EVENTS',
                  style: TextStyle(
                    fontSize: 20.sp,
                    letterSpacing: 2.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // List of upcoming events
              Expanded(
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : restEvents.isEmpty
                        ? Center(
                            child: Text('No more upcoming events', style: TextStyle(color: Colors.white70)),
                          )
                        : ListView.builder(
                            itemCount: restEvents.length,
                            itemBuilder: (context, index) {
                              final event = restEvents[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 20.h),
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.event_rounded,
                                          size: 20.sp,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Text(
                                            event.title,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time_filled,
                                          size: 20.sp,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          _formatEventTime(event.dueDate),
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatEventTime(Timestamp dueDate) {
    final date = dueDate.toDate();
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final dateStr = isToday
        ? 'Today'
        : '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final timeStr = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return '$dateStr, $timeStr';
  }
}
