import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ccm/blocs/tab/tab.dart';
import 'package:ccm/transactions/models/models.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  TabBloc() : super(AppTab.transactions);

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}
