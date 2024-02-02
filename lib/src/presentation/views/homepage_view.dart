import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:swifty_companion/src/config/app_colors.dart';
import 'package:swifty_companion/src/config/router/app_router.dart';
import 'package:swifty_companion/src/domain/models/coalition/coalition.dart';
import 'package:swifty_companion/src/domain/models/event/event.dart';
import 'package:swifty_companion/src/domain/models/student/student.dart';
import 'package:swifty_companion/src/presentation/cubits/homepage/homepage_cubit.dart';
import 'package:swifty_companion/src/presentation/widgets/coalition_banner.dart';
import 'package:swifty_companion/src/presentation/widgets/coalition_card.dart';
import 'package:swifty_companion/src/presentation/widgets/event_card.dart';
import 'package:swifty_companion/src/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class HomepageView extends HookWidget {
  const HomepageView({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    final homepageCubit = BlocProvider.of<HomepageCubit>(context);
    final TextEditingController searchController = TextEditingController();

    useEffect(() {
      homepageCubit.fetchData();
      return;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomSearchBar(
          controller: searchController,
          onChanged: (query) async {
            if (query != "") {
              homepageCubit.searchStudent(query: query);
            }
          },
          margin: const EdgeInsets.all(8),
          width: double.maxFinite,
          hintText: tr("homepage.search_student_by_login"),
        ),toolbarHeight: 80,
      ),
      body: BlocBuilder<HomepageCubit, HomepageState>(
        builder: (_, state) {
            if (state.runtimeType == HomepageLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            else if (state.runtimeType == HomepageFailed) {
              return const Center(child: Icon(Icons.refresh));
            }
            else {
              return _buildBody(homepageCubit, searchController);
            }
        }
      )
    );
  }

  Widget _buildBody(HomepageCubit homepageCubit, TextEditingController searchController) {
    return SafeArea(
      left: false,
      right: false,
      child: Column(
        children: [
          _buildStudentSearchWidget(homepageCubit, searchController),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24,),
                  _buildCoalitionsWidget(homepageCubit),
                  const SizedBox(height: 24,),
                  _buildEventsWidget(homepageCubit),
                  const SizedBox(height: 24,),
                  GestureDetector(
                    onTap: () {
                      homepageCubit.logOut();
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.alert.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text(tr("homepage.logout"),
                            style: const TextStyle(
                              color: AppColors.alert,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                          ),),
                        ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentSearchWidget(HomepageCubit homepageCubit, TextEditingController searchController) {
    List<Student> students = homepageCubit.state.students ?? [];
    return Material(
      elevation: 4,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black87.withOpacity(0.25),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8, bottom: 24),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4,),
              BlocBuilder<HomepageCubit, HomepageState>(
                  builder: (context, state) {
                    if (state.runtimeType == HomepageSearchLoading) {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                    if (students.isEmpty && searchController.text != "") {
                      return Center(
                        child: Text("${tr("errors.0_results_for_given_query")}: ${searchController.text}",
                          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      );
                    } else if (students.isEmpty) {
                      return const SizedBox();
                    }
                    return _studentResultWidget(students[0]);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoalitionsWidget(HomepageCubit homepageCubit) {
    List<Coalition>? coalitions = homepageCubit.state.coalitions;
    if (coalitions == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr("coalitions.coalitions"), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          const SizedBox(height: 24,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < coalitions.length; i++)
                  CoalitionCard(
                    coalition: coalitions[i],
                    first: i == 0,
                    last: i == coalitions.length - 1,
                  ),
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget _buildEventsWidget(HomepageCubit homepageCubit) {
    List<Event>? events = homepageCubit.state.events;
    if (events == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr("homepage.events"), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          const SizedBox(height: 24,),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              height: 298,
              child: ListView.builder(
                itemCount: events.length, // Adjust this based on your actual item count
                itemBuilder: (context, index) {
                  return EventCardWidget(event: events[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _studentResultWidget(Student student) {
    return GestureDetector(
      onTap: () {
        appRouter.push(StudentRoute(studentId: student.id.toString()));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          //border: Border.all(color: AppColors.primary)
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(64),
              child: Image.network(student.picture, width: 80, height: 80, fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Center(
                      child: Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.withOpacity(0.3),
                          child: const Icon(Icons.person, size: 32, color: Colors.grey,)
                      ));
                },
              ),
            ),
            const SizedBox(width: 16,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                const SizedBox(height: 8,),
                Text(student.login),
                Text(student.email),
              ],
            ),
            const Expanded(child: SizedBox()),
            const Icon(Icons.arrow_forward_ios, size: 16,)
          ],
        ),
      ),
    );
  }
}