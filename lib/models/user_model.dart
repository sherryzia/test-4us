class UserModel {
  final String uid;
  final String name;
  final String profileImageUrl;
  final String ageGroup;
  final String selectedOccupation;
  final String currentIncome;
  final String selectedDesiredOccupation;
  final String desiredIncome;
  final String debtAmount;
  final String selectedDebtType;
  final String mobileNumber;
  final String address;
  final String goal;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.profileImageUrl,
    required this.ageGroup,
    required this.selectedOccupation,
    required this.currentIncome,
    required this.selectedDesiredOccupation,
    required this.desiredIncome,
    required this.debtAmount,
    required this.selectedDebtType,
    required this.mobileNumber,
    required this.address,
    required this.goal,
    required this.email,
  });
}
