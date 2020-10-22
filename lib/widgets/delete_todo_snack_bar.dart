import 'package:flutter/material.dart';
import 'package:transactions_repository/transactions_repository.dart';

class DeleteTransactionSnackBar extends SnackBar {
  DeleteTransactionSnackBar({
    Key key,
    @required Transaction transaction,
    @required VoidCallback onUndo,
  }) : super(
          key: key,
          content: Text(
            'Deleted ${transaction.category} - ${transaction.description}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: onUndo,
          ),
        );
}

class CompleteTransactionSnackBar extends SnackBar {
  CompleteTransactionSnackBar({
    Key key,
    @required Transaction transaction,
    @required VoidCallback onUndo,
  }) : super(
    key: key,
    content: Text(
      'Cleared Dues/Advances ${transaction.category} - ${transaction.description}',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    duration: Duration(seconds: 2),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: onUndo,
    ),
  );
}