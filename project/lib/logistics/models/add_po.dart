import 'package:equatable/equatable.dart';

class AddPO extends Equatable {
  const AddPO({
    required this.id,
    required this.poIdName,
    required this.poStatus,
    required this.poDate,
    required this.poContactName,
    required this.poPhone,
    required this.poDelivery,
  });

  final int id;
  final String poIdName;
  final String poStatus;
  final String poDate;
  final String poContactName;
  final String poPhone;
  final String poDelivery;

  @override
  List<Object?> get props => [poIdName, poStatus, poDate, poContactName, poPhone, poDelivery];
}
