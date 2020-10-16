import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccm/authentication/authentication.dart';
import 'package:ccm/home/home.dart';
import 'package:ccm/login/login.dart';
import 'package:ccm/splash/splash.dart';
import 'package:ccm/theme.dart';
import 'package:transactions_repository/transactions_repository.dart';

import 'transactions/bloc/transactions.dart';

class TransactionApp extends StatelessWidget {
  TransactionApp({
    Key key,
    @required this.authenticationRepository,
    @required this.firebaseTransactionRepository,
  })  : assert(authenticationRepository != null),
        assert(firebaseTransactionRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final FirebaseTransactionRepository firebaseTransactionRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: firebaseTransactionRepository)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider<TransactionsBloc>(
            create: (context) => TransactionsBloc(
                transactionsRepository: firebaseTransactionRepository,
                authenticationRepository: authenticationRepository,
            )
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget{
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: theme,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                      (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                      (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }

}