import 'dart:developer';

import 'package:ShoolManagementSystem/src/data/evaluation_criteria.dart';
import 'package:ShoolManagementSystem/src/screens/avinya_type_details.dart';
import 'package:ShoolManagementSystem/src/screens/evaluation_criteria.dart';
import 'package:ShoolManagementSystem/src/screens/evaluation_details.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import '../data.dart';
import '../routing.dart';
import '../screens/sign_in.dart';
import '../widgets/fade_transition_page.dart';
import 'evaluation_criteria_details.dart';
import 'scaffold.dart';

/// Builds the top-level navigator for the app. The pages to display are based
/// on the `routeState` that was parsed by the TemplateRouteParser.
class SMSNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const SMSNavigator({
    required this.navigatorKey,
    super.key,
  });

  @override
  State<SMSNavigator> createState() => _SMSNavigatorState();
}

class _SMSNavigatorState extends State<SMSNavigator> {
  final _signInKey = const ValueKey('Sign in');
  final _scaffoldKey = const ValueKey('App scaffold');
  final _avinyaTypeDetailsKey = const ValueKey('Avinya Type details screen');
  final _evaluationDetailsKey = const ValueKey('Evaluations details screen');
  final _evaluationCriteriaDetailsKey =
      const ValueKey('Evaluation Criteria details screen');

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final authState = SMSAuthScope.of(context);
    final pathTemplate = routeState.route.pathTemplate;

    AvinyaType? selectedAvinyaType;
    if (pathTemplate == '/address_type/:id') {
      selectedAvinyaType = campusFeedbackSystemInstance.avinyaTypes
          ?.firstWhereOrNull(
              (at) => at.id.toString() == routeState.route.parameters['id']);
    }
    Evaluation? selectedEvaluation;
    if (pathTemplate == '/evaluation/:id') {
      selectedEvaluation = campusFeedbackSystemInstance.evaluations!
          .firstWhereOrNull(
              (a) => a.id.toString() == routeState.route.parameters['id']);
    }
    EvaluationCriteria? selectedEvaluationCriteria;
    if (pathTemplate == '/evaluation_criteria/id') {
      selectedEvaluationCriteria =
          campusFeedbackSystemInstance.evaluation_criteria!.firstWhereOrNull(
              (a) => a.id.toString() == routeState.route.parameters['id']);
    }

    if (pathTemplate == '/#access_token') {
      log('Navigator $routeState.route.parameters.toString()');
      log('Navigator $routeState.route.queryParameters.toString()');
    }

    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {
        // When a page that is stacked on top of the scaffold is popped, display
        // the /avinya_types tab in SMSScaffold.

        if (route.settings is Page &&
            (route.settings as Page).key == _avinyaTypeDetailsKey) {
          routeState.go('/avinya_types/popular');
        }
        if (route.settings is Page &&
            (route.settings as Page).key == _evaluationDetailsKey) {
          routeState.go('/evaluations/popular');
        }
        if (route.settings is Page &&
            (route.settings as Page).key == _evaluationCriteriaDetailsKey) {
          routeState.go('/evaluation_criterias/popular');
        }

        return route.didPop(result);
      },
      pages: [
        // if (routeState.route.pathTemplate == '/apply')
        //   // Display the sign in screen.
        //   FadeTransitionPage<void>(
        //     key: _applyKey,
        //     child: ApplyScreen(
        //         ),
        //   )
        if (routeState.route.pathTemplate == '/signin')
          // Display the sign in screen.
          FadeTransitionPage<void>(
            key: _signInKey,
            child: SignInScreen(
              onSignIn: (credentials) async {
                var signedIn = await authState.signIn(
                    credentials.username, credentials.password);
                if (signedIn) {
                  await routeState
                      .go('/evaluations/popular'); //see as first page
                }
              },
            ),
          )
        else ...[
          // Display the app
          FadeTransitionPage<void>(
            key: _scaffoldKey,
            child: const SMSScaffold(),
          ),
          // Add an additional page to the stack if the user is viewing a book
          // or an author
          if (selectedAvinyaType != null)
            MaterialPage<void>(
              key: _avinyaTypeDetailsKey,
              child: AvinyaTypeDetailsScreen(
                avinyaType: selectedAvinyaType,
              ),
            )
          else if (selectedEvaluation != null)
            MaterialPage<void>(
              key: _evaluationDetailsKey,
              child: EvaluationDetailsScreen(
                evaluation: selectedEvaluation,
              ),
            )
          else if (selectedEvaluationCriteria != null)
            MaterialPage<void>(
              key: _evaluationCriteriaDetailsKey,
              child: EvaluationCriteriaDetailsScreen(
                evaluationCriteria: selectedEvaluationCriteria,
              ),
            )
        ],
      ],
    );
  }
}
