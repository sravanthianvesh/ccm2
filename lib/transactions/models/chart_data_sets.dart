class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class LinearExpenditure {
  final String category;
  final double expenditure;

  LinearExpenditure(this.category, this.expenditure);

  @override
  String toString() {
    return 'LinearExpenditure { Category: $category, Expenditure: $expenditure}';
  }
}