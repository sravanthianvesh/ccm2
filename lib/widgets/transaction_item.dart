import 'package:ccm/widgets/slidable_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transactions_repository/transactions_repository.dart';

class TransactionItem extends StatelessWidget {
  final Function(SlidableAction action) onDismissed;
  final GestureTapCallback onTap;
  final Transaction transaction;

  TransactionItem({
    Key key,
    @required this.onDismissed,
    @required this.onTap,
    @required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlidableWidget(
      key: Key('__transaction_item_${transaction.id}'),
      onDismissed: onDismissed,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0.0, 1.0),
                    color: Colors.grey[400],
                    blurRadius: 0.5,
                    spreadRadius: 0.5,
                  ),
                ]
            ),
            child:IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      transaction.date,
                      style: GoogleFonts.openSans(
                        textStyle: Theme.of(context).textTheme.bodyText1,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0,8.0,0.0,8.0),
                    child: VerticalDivider(thickness: .5, color: Colors.grey,),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          transaction.category,
                          style: GoogleFonts.openSans(
                            textStyle: Theme.of(context).textTheme.bodyText1,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          transaction.description,
                          style: Theme.of(context).textTheme.bodyText2,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          transaction.quantity,
                          style: GoogleFonts.openSans(
                            textStyle: Theme.of(context).textTheme.bodyText2,
                            color: const Color(0xFFFFB74D),
                          ),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0,8.0,0.0,8.0),
                    child: VerticalDivider(thickness: .5, color: Colors.grey,),
                  ),

                  transaction.totalAmount != transaction.amountPaid ? Column(
                    children: [
                      Text(
                        'Billed: \n ${ transaction.totalAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.openSans(
                          textStyle: Theme.of(context).textTheme.bodyText1,
                          color: transaction.totalAmount == transaction.amountPaid ? const Color(0xFF33691E) : const Color(0xFFFF7043),
                        ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.amountPaid < transaction.totalAmount ? 'Paid: \n ${ transaction.amountPaid.toStringAsFixed(2)}' : transaction.amountPaid > transaction.totalAmount ? 'Paid: \n ${ transaction.amountPaid.toStringAsFixed(2)}' : '',
                        style: GoogleFonts.openSans(
                          textStyle: Theme.of(context).textTheme.bodyText1,
                          color: transaction.amountPaid < transaction.totalAmount ? const Color(0xFFF44336) : transaction.amountPaid > transaction.totalAmount ? const Color(0xFFFFB74D) : const Color(0xFFFFB74D),
                        ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.amountPaid < transaction.totalAmount ? 'Due: \n ${ (transaction.totalAmount - transaction.amountPaid).toStringAsFixed(2)}' : transaction.amountPaid > transaction.totalAmount ? 'Adv.: \n ${ (transaction.amountPaid - transaction.totalAmount).toStringAsFixed(2)}' : '',
                        style: GoogleFonts.openSans(
                          textStyle: Theme.of(context).textTheme.bodyText1,
                          color: transaction.amountPaid < transaction.totalAmount ? const Color(0xFFF44336) : transaction.amountPaid > transaction.totalAmount ? const Color(0xFFFFB74D) : const Color(0xFFFFB74D),
                        ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ) : Text(
                    '${ transaction.totalAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.openSans(
                      textStyle: Theme.of(context).textTheme.bodyText1,
                      color: transaction.totalAmount == transaction.amountPaid ? const Color(0xFF33691E) : const Color(0xFFFF7043),
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
ListTile(
          onTap: onTap,
          title: Hero(
            tag: '${transaction.id}__heroTag',
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                transaction.category,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
          subtitle: transaction.description.isNotEmpty
              ? Text(
                  transaction.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1,
                )
              : null,
        ),
*/