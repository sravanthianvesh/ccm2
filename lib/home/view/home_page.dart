import 'package:ccm/blocs/tab/tab.dart';
import 'package:ccm/home/view/home_screen.dart';
import 'package:ccm/transactions/bloc/filtered_transactions.dart';
import 'package:ccm/transactions/bloc/stats.dart';
import 'package:ccm/transactions/bloc/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transactions_repository/transactions_repository.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key key,
  })  : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TabBloc>(
          create: (context) => TabBloc(),
        ),
        BlocProvider<FilteredTransactionsBloc>(
          create: (context) =>
              FilteredTransactionsBloc(
                transactionsBloc: BlocProvider.of<TransactionsBloc>(context),
              ),
        ),
        BlocProvider<StatsBloc>(
          create: (context) =>
              StatsBloc(
                transactionsBloc: BlocProvider.of<TransactionsBloc>(context),
              ),
        ),
      ],
      child: HomeScreen(),
    );
  }
}

/*class HomePageView extends StatefulWidget{
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => BlocProvider.of<AuthenticationBloc>(context),
        ),
        BlocProvider<TabBloc>(
          create: (context) => TabBloc(),
        ),
        BlocProvider<TransactionsBloc>(
          create: (context) =>
          TransactionsBloc(authenticationRepository: Authentica)
            ..add(LoadTransactions()),
        ),
        BlocProvider<FilteredTransactionsBloc>(
          create: (context) =>
              FilteredTransactionsBloc(
                transactionsBloc: BlocProvider.of<TransactionsBloc>(context),
              ),
        ),
        BlocProvider<StatsBloc>(
          create: (context) =>
              StatsBloc(
                transactionsBloc: BlocProvider.of<TransactionsBloc>(context),
              ),
        ),
      ],
      child: HomeScreen(),
    );
  }

}
*/
