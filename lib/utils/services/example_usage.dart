// Example usage of the optimized spark, repository, and async spark services
// ignore_for_file: unintended_html_in_doc_comment

import 'package:patients/utils/services/async_spark.dart';
import 'package:patients/utils/services/repository.dart';

// Example of a synchronous repository
class CounterRepository extends Repository<int> {
  @override
  int get initialState => 0;
}

// Example of an async spark
class UserProfileSpark extends AsyncSpark<Map<String, dynamic>> {
  UserProfileSpark()
      : super(
          // Simulate async loading of user data
          Future.delayed(
            Duration(seconds: 1),
            () {
              return {
                'name': 'John Doe',
                'email': 'john@example.com',
                'age': 30,
              };
            },
          ),
        );
}

// Example of how to use these services in a widget
/*
class ExampleWidget extends Feature<ExampleBloc> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Using a synchronous repository
        StreamBuilder<int>(
          stream: counterRepo.watch,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Count: ${snapshot.data}');
            }
            return CircularProgressIndicator();
          }
        ),
        
        // Using an async spark
        StreamBuilder<AsyncState<Map<String, dynamic>>>(
          stream: userProfileSpark.watch,
          builder: (context, snapshot) {
            return snapshot.data.when(
              loading: () => CircularProgressIndicator(),
              data: (user) => Text('User: ${user['name']}'),
              error: (err) => Text('Error: $err'),
            );
          }
        ),
      ],
    );
  }
}
*/
