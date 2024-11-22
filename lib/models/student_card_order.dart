class StudentCardOrder {
  final String studentNumber;
  final String fullName;
  final String course;
  final String photoPath;
  final double amount;
  final DateTime orderDate;
  final String status;

  StudentCardOrder({
    required this.studentNumber,
    required this.fullName,
    required this.course,
    required this.photoPath,
    this.amount = 100.00, // Default amount for student card
    required this.orderDate,
    this.status = 'Pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'studentNumber': studentNumber,
      'fullName': fullName,
      'course': course,
      'photoPath': photoPath,
      'amount': amount,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }

  factory StudentCardOrder.fromJson(Map<String, dynamic> json) {
    return StudentCardOrder(
      studentNumber: json['studentNumber'],
      fullName: json['fullName'],
      course: json['course'],
      photoPath: json['photoPath'],
      amount: json['amount'],
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'],
    );
  }
}
