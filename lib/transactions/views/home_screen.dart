import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccm/blocs/tab/tab.dart';
import 'package:ccm/widgets/widgets.dart';
import 'package:ccm/transactions/models/models.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text('CCM'),
            actions: [
              FilterButton(visible: activeTab == AppTab.transactions),
              ExtraActions(),
            ],
          ),
          body: activeTab == AppTab.transactions ? FilteredTransactions() : Stats(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/addEditTransaction', (route) => false);
            },
            child: Icon(Icons.add),
            tooltip: 'Add Transaction',
          ),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) =>
                BlocProvider.of<TabBloc>(context).add(UpdateTab(tab)),
          ),
        );
      },
    );
  }
}
