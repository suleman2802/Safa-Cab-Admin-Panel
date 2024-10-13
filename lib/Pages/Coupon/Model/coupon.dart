class Coupon {
  final int id;
  final String couponCode;
  final double couponDiscountAmount;
  final String validFrom;
  final String validTo;
  final String status;

  Coupon(this.id, this.couponCode, this.couponDiscountAmount, this.validFrom,
      this.validTo, this.status);

  factory Coupon.fromJson(Map<String, dynamic> json) {
    try {
      return Coupon(
        json['id'],
        json['code'],
        json['discount'].toDouble(),
        json['valid_from'],
        json['valid_to'],
        json['status'],
      );
    } catch (error) {
      print(error);
      return Coupon(-1, "", 0.0, "", "", "");
    }
  }
}
