import '../../main.dart';

@Entity()
class Investigation {
  @Id(assignable: true)
  int id = 0;
  String name = '';
  int price = 200;
}

class InvestigationsRepository extends CRUD<Investigation> {}

final investigationsRepository = InvestigationsRepository();

class InvestigationsBloc with ChangeNotifier {
  BuildContext context;
  InvestigationsBloc(this.context);

  late List<Investigation> investigations = investigationsRepository.getAll();

  void put(Investigation investigation) {
    investigationsRepository.put(investigation);
    investigations = investigationsRepository.getAll();
    notifyListeners();
  }

  void remove(int id) {
    investigationsRepository.remove(id);
    investigations = investigationsRepository.getAll();
    notifyListeners();
  }
}
