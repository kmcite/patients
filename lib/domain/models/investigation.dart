import 'package:patients/main.dart';

@Entity()
class Investigation {
  @Id()
  int id = 0;

  String name = '';
  String description = '';
  String category = ''; // Lab, Radiology, Cardiology, etc.

  double price = 200.0;
  String currency = 'USD';

  @Property(type: PropertyType.date)
  DateTime? scheduledDate;

  @Property(type: PropertyType.date)
  DateTime? completedDate;

  String results = '';
  String notes = '';

  int statusIndex = InvestigationStatus.pending.index;

  @Transient()
  InvestigationStatus get status => InvestigationStatus.values[statusIndex];

  @Transient()
  set status(InvestigationStatus value) {
    statusIndex = value.index;
  }

  @Transient()
  bool get isCompleted => status == InvestigationStatus.completed;

  @Transient()
  String get formattedPrice => '$currency ${price.toStringAsFixed(2)}';
}

enum InvestigationStatus { pending, inProgress, completed, cancelled, failed }
