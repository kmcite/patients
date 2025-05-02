import 'dart:async';

import 'package:forui/forui.dart';
import 'package:patients/domain/api/investigations.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/domain/models/investigation.dart';

import '../main.dart';

class InvestigationsEvent {
  const InvestigationsEvent();
}

class RemoveInvestigationsEvent extends InvestigationsEvent {
  final int id;
  const RemoveInvestigationsEvent(this.id);
}

class PutInvestigationsEvent extends InvestigationsEvent {
  final Investigation investigation;
  const PutInvestigationsEvent(this.investigation);
}

class ToggleEditingInvestigationsEvent extends InvestigationsEvent {
  const ToggleEditingInvestigationsEvent();
}

typedef InvestigationsState = ({
  bool editing,
  List<Investigation> investigations,
});

class InvestigationsBloc
    extends Bloc<InvestigationsEvent, InvestigationsState> {
  StreamSubscription? _investigationsSubscription;
  InvestigationsBloc() {
    on<PutInvestigationsEvent>(
      (event) {
        investigationsRepository.put(event.investigation);
      },
    );
    on<RemoveInvestigationsEvent>(
      (event) {
        investigationsRepository.remove(event.id);
      },
    );
    on<ToggleEditingInvestigationsEvent>(
      (event) {
        emit(
          (editing: !state.editing, investigations: state.investigations),
        );
      },
    );
    _investigationsSubscription = investigationsRepository.watch().listen(
      (investigations) {
        emit(
          (editing: state.editing, investigations: investigations),
        );
      },
    );
  }
  @override
  final initialState = (
    editing: false,
    investigations: investigationsRepository.getAll(),
  );
  @override
  void dispose() {
    _investigationsSubscription?.cancel();
    super.dispose();
  }
}

late InvestigationsBloc _investigations;

class InvestigationsPage extends UI {
  const InvestigationsPage({super.key});
  @override
  void didMountWidget(BuildContext context) {
    _investigations = InvestigationsBloc();
  }

  @override
  void didUnmountWidget() {
    _investigations.dispose();
    super.didUnmountWidget();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: Text('Investigations'),
        prefixActions: [
          FButton.icon(
            onPress: () => navigator.back(),
            child: FIcon(FAssets.icons.x),
          )
        ],
        suffixActions: [
          FButton.icon(
            onPress: () => _investigations(ToggleEditingInvestigationsEvent()),
            child: FIcon(
              _investigations().editing
                  ? FAssets.icons.notebookPen
                  : FAssets.icons.pen,
            ),
          ),
          FButton.icon(
            onPress: () => _investigations(
              PutInvestigationsEvent(
                Investigation(),
              ),
            ),
            child: FIcon(FAssets.icons.plus),
          ),
        ],
      ),
      content: ListView.builder(
        itemCount: _investigations().investigations.length,
        itemBuilder: (context, index) {
          final investigation =
              _investigations().investigations.elementAt(index);
          return FLabel(
            axis: Axis.vertical,
            key: Key(investigation.id.toString()),
            child: _investigations().editing
                ? Row(
                    children: [
                      Expanded(
                        child: FTextField(
                          initialValue: investigation.name,
                          onChange: (value) {
                            _investigations(
                              PutInvestigationsEvent(
                                investigation..name = value,
                              ),
                            );
                          },
                        ),
                      ),
                      FButton.icon(
                        onPress: () {
                          _investigations(
                            RemoveInvestigationsEvent(investigation.id),
                          );
                        },
                        child: FIcon(FAssets.icons.delete),
                      ).pad(),
                    ],
                  )
                : FAlert(
                    icon: FIcon(FAssets.icons.ambulance),
                    title: investigation.name.text(),
                  ),
          );
        },
      ),
    );
  }
}
