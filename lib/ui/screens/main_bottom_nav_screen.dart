import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/cancelled_tasks_screen.dart';
import 'package:task_manager/ui/screens/completed_tasks_screen.dart';
import 'package:task_manager/ui/screens/new_tasks_screen.dart';
import 'package:task_manager/ui/screens/progress_screen.dart';

class MainBottomNavbar extends StatefulWidget {
  const MainBottomNavbar({super.key});

  @override
  State<MainBottomNavbar> createState() => _MainBottomNavbarState();
}

class _MainBottomNavbarState extends State<MainBottomNavbar> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    NewTasksScreen(),
    ProgressScreen(),
    CompletedTasksScreen(),
    CancelledTasksScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index){
          _selectedIndex = index;
          setState(() {});
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add),label: 'New'),
          BottomNavigationBarItem(icon: Icon(Icons.hourglass_bottom),label: 'In Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.check),label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.cancel),label: 'Cancelled'),
        ],
      ),
    );
  }
}
