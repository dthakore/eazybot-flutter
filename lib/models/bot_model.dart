class BotModel {
  final int id;
  final String title;
  final String status;
  final String exchange;
  final String coinPair;
  final double totalProfit;
  final double todayProfit;
  final String lastTrade;
  final String strategy;
  final String strategyType;
  final String cycleType;
  final String category;
  final double initialCapital;
  final double currentCapital;
  final double availableQuoteCoins;
  final String runtime;

  BotModel({
    required this.id,
    required this.title,
    required this.status,
    required this.strategyType,
    required this.exchange,
    required this.coinPair,
    required this.totalProfit,
    required this.todayProfit,
    required this.lastTrade,
    required this.strategy,
    required this.cycleType,
    required this.category,
    required this.initialCapital,
    required this.currentCapital,
    required this.availableQuoteCoins,
    required this.runtime,

  });

  factory BotModel.fromJson(Map<String, dynamic> json) {
    return BotModel(
      id: json['id'],
      title: json['title'] ?? "",
      status: json['status'] ?? "",
      strategy: json['strategy'] ?? "",
      strategyType: json['strategy_type'] ?? "",
      cycleType: json['cycle_type'] ?? "",
      exchange: json['exchange'] ?? "",
      coinPair: json['coin_pair'] ?? "",
      totalProfit: (json['total_profit'] ?? 0).toDouble(),
      todayProfit: (json['today_profit'] ?? 0).toDouble(),
      initialCapital: (json['initial_capital'] ?? 0).toDouble(),
      currentCapital: (json['current_capital'] ?? 0).toDouble(),
      availableQuoteCoins: (json['available_quote_coins'] ?? 0).toDouble(),
      runtime: json['runtime'] ?? "",
      category:json['category']??"-",
      lastTrade: json['last_trade'] ?? "",
    );
  }
}