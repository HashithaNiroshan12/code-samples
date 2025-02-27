import 'package:ShoolManagementSystem/src/screens/avinya_types.dart';
import 'package:ShoolManagementSystem/src/screens/evaluation_criteria.dart';
import 'package:ShoolManagementSystem/src/screens/evaluations.dart';
import 'package:flutter/material.dart';

import '../routing.dart';
import '../widgets/fade_transition_page.dart';
import 'scaffold.dart';

/// Displays the contents of the body of [SMSScaffold]
class SMSScaffoldBody extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const SMSScaffoldBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var currentRoute = RouteStateScope.of(context).route;

    // A nested Router isn't necessary because the back button behavior doesn't
    // need to be customized.
    return Navigator(
      key: navigatorKey,
      onPopPage: (route, dynamic result) => route.didPop(result),
      pages: [
        // if (currentRoute.pathTemplate.startsWith('/avinya_types') ||
        //     currentRoute.pathTemplate == '/')
        //   const FadeTransitionPage<void>(
        //     key: ValueKey('avinya_types'),
        //     child: AvinyaTypeScreen(),
        //   )
        // else
        if (currentRoute.pathTemplate.startsWith('/evaluations') ||
            currentRoute.pathTemplate == '/')
          const FadeTransitionPage<void>(
            key: ValueKey('evaluations'),
            child: EvaluationScreen(),
          )
        else if (currentRoute.pathTemplate.startsWith('/evaluation_criterias'))
          const FadeTransitionPage<void>(
            key: ValueKey('evaluation_Criteria'),
            child: EvaluationCriteriaScreen(),
          )

        // Avoid building a Navigator with an empty `pages` list when the
        // RouteState is set to an unexpected path, such as /signin.
        //
        // Since RouteStateScope is an InheritedNotifier, any change to the
        // route will result in a call to this build method, even though this
        // widget isn't built when those routes are active.
        else
          FadeTransitionPage<void>(
            key: const ValueKey('empty'),
            child: Container(),
          ),
      ],
    );
  }
}
