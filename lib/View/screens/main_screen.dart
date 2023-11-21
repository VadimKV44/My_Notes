import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_notes/Model/local_storage/databases/notes_data_base.dart';
import 'package:my_notes/Model/local_storage/databases/tasks_data_base.dart';
import 'package:my_notes/Presenter/functions/show_bottom_menu.dart';
import 'package:my_notes/View/consts/strings.dart';
import 'package:my_notes/View/screens/tabs/notes_screen.dart';
import 'package:my_notes/View/screens/tabs/tasks_screen.dart';
import 'package:my_notes/View/widgets/bottom_sheets/settings_bottom_sheet_widget.dart';
import 'package:my_notes/View/widgets/settings_icon_button_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  late TabController _tabController;

  bool _isOpenBoxes = false;

  @override
  void initState() {
    super.initState();
    _openingBoxes();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Scaffold(
        appBar: _isOpenBoxes ? AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          centerTitle: true,
          title: TabBar(
            indicatorColor: Colors.transparent,
            controller: _tabController,
            isScrollable: true,
            labelStyle: Theme.of(context).textTheme.titleLarge,
            unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
            labelColor: Theme.of(context).colorScheme.outline,
            unselectedLabelColor: Theme.of(context).colorScheme.outline,
            splashBorderRadius: BorderRadius.circular(16.0),
            splashFactory: NoSplash.splashFactory,
            indicatorPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: -10.0),
            indicatorWeight: 0.0,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(16.0),
            ),
            tabs: const [
              Tab(text: Strings.notes),
              Tab(text: Strings.tasks),
            ],
            onTap: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 100),
                curve: Curves.linear,
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 10.0, top: 10.0),
              child: SettingsIconButtonWidget(
                onTap: () => showBottomSheetMenu(
                  context: context,
                  bottomSheetMenu: const SettingsBottomSheetWidget(),
                ),
              ),
            ),
          ],
        ) : null,
        body: _isOpenBoxes ? SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _tabController.animateTo(index);
                  },
                  children: const [
                    NotesScreen(),
                    TasksScreen(),
                  ],
                ),
              ),
            ],
          ),
        ): Center(
          child: LoadingAnimationWidget.inkDrop(
              size: 100,
              color: Theme.of(context).colorScheme.secondary
            // color: Colors.red
          ),
        ),
      ),
    );
  }

  void _openingBoxes() async {
    bool isOpenNotesBox = await NotesDataBase.openNotesBox();
    bool isOpenTaskBox = await TasksDataBase.openTaskBox();
    setState(() {
      if (isOpenNotesBox && isOpenTaskBox) {
        _isOpenBoxes = true;
      }
    });
  }
}
