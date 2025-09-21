import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:patients/domain/api/user_repository.dart';
import 'package:patients/domain/models/user.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class UserBloc extends Bloc<UserPage> {
  late final UserRepository userRepository;

  @override
  void initState() {
    userRepository = watch<UserRepository>();
  }

  Duration get jobDuration => userRepository.user.jobDuration;
  String get name => userRepository.user.name;
  ShowDurationIn get showDurationIn => userRepository.showDurationIn;
  DateTime get jobStartedOn => userRepository.user.jobStartedOn;

  void setName(String name) => userRepository.setName(name);
  void setJobStartedOn(DateTime date) => userRepository.setJobStartedOn(date);
  void toggleShowDurationIn() => userRepository.toggleShowDurationIn();
}

class UserPage extends Feature<UserBloc> {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duration = controller.jobDuration;

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.name),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: controller.name,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      onChanged: controller.setName,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Experience Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.work_history,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Work Experience',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Duration Display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _formatDuration(
                                duration, controller.showDurationIn),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          Text(
                            'of experience',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Job Start Date
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Job Started On'),
                      subtitle: Text(controller.jobStartedOn.format),
                      contentPadding: EdgeInsets.zero,
                    ),

                    const SizedBox(height: 16),

                    // Duration Format Toggle
                    OutlinedButton.icon(
                      onPressed: controller.toggleShowDurationIn,
                      icon: const Icon(Icons.swap_horiz),
                      label: Text('Show in ${controller.showDurationIn.name}'),
                    ),

                    const SizedBox(height: 16),

                    // Update Date Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final selected = await showDatePicker(
                            context: context,
                            initialDate: controller.jobStartedOn,
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          );

                          if (selected != null) {
                            controller.setJobStartedOn(selected);
                          }
                        },
                        icon: const Icon(Icons.edit_calendar),
                        label: const Text('Update Job Start Date'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration, ShowDurationIn showIn) {
    switch (showIn) {
      case ShowDurationIn.years:
        return '${(duration.inDays / 365).toStringAsFixed(2)} years';
      case ShowDurationIn.months:
        return '${(duration.inDays / 30).toStringAsFixed(2)} months';
      case ShowDurationIn.days:
        return '${duration.inDays} days';
      case ShowDurationIn.hours:
        return '${duration.inHours} hours';
      case ShowDurationIn.minutes:
        return '${duration.inMinutes} minutes';
      case ShowDurationIn.seconds:
        return '${duration.inSeconds} seconds';
    }
  }
}

extension on DateTime {
  String get format {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
