class PrintSetting {
  String? designName;
  double pageHeight;
  double pageWidth;
  double marginHorizontal;
  double marginVertical;
  double? paddingHorizontal = 0;
  double? paddingVertical = 0;
  double? cardHeight = 3.34;
  double? cardWidth = 2.12;

  PrintSetting(
      {this.designName,
      this.pageHeight = 11.69,
      this.pageWidth = 8.27,
      this.marginHorizontal = 0,
      this.marginVertical = 0,
      this.paddingHorizontal,
      this.paddingVertical,
      this.cardHeight,
      this.cardWidth});

  Map toMap() {
    return {
      'designName': designName,
      'pageHeight': pageHeight.toString(),
      'pageWidth': pageWidth.toString(),
      'marginHorizontal': marginHorizontal.toString(),
      'marginVertical': marginVertical.toString(),
      'paddingHorizontal': paddingHorizontal.toString(),
      'paddingVertical': paddingVertical.toString(),
      'cardHeight': cardHeight.toString(),
      'cardWidth': cardWidth.toString()
    };
  }

  factory PrintSetting.fromMap(Map json) {
    return PrintSetting(
        designName: json['designName'],
        pageHeight: json['pageHeight'],
        pageWidth: json['pageWidth'],
        marginHorizontal: json['marginHorizontal'],
        marginVertical: json['marginVertical'],
        paddingHorizontal: json['paddingHorizontal'],
        paddingVertical: json['paddingVertical'],
        cardHeight: json['cardHeight'],
        cardWidth: json['cardWidth']);
  }
}
