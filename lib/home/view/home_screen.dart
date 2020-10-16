import 'package:ccm/authentication/bloc/authentication_bloc.dart';
import 'package:ccm/home/widgets/avatar.dart';
import 'package:ccm/transactions/views/add_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccm/blocs/tab/tab.dart';
import 'package:ccm/widgets/widgets.dart';
import 'package:ccm/transactions/models/models.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.bloc<AuthenticationBloc>().state.user;
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              FilterButton(visible: activeTab == AppTab.transactions),
              ExtraActions(),
              IconButton(
                key: const Key('homePage_logout_iconButton'),
                icon: const Icon(Icons.exit_to_app),
                onPressed: () => context
                    .bloc<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested()),
              )
            ],
          ),
          body: activeTab == AppTab.transactions ? FilteredTransactions() : Stats(),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Row(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Avatar(photo: user.photo),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            Text(user.name ?? '', style: textTheme.headline5, overflow: TextOverflow.fade, softWrap: true,),
                            const SizedBox(height: 4.0),
                            Text(user.email, style: textTheme.headline6, overflow: TextOverflow.fade, softWrap: true,),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                ListTile(
                  title: Text('Reports'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddEditPage()),);
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
