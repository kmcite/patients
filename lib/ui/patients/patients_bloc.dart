// DEPRECATED: This file is deprecated in favor of the new architecture
// Use PatientsRepository with BlocWidget pattern instead

/*
This file contained the old patients bloc implementation using states_rebuilder.
It has been replaced with the new architecture using:
- PatientsRepository (extends CrudRepository<Patient>)
- PatientsPageBloc (extends Bloc)
- PatientsPage (extends BlocWidget<PatientsPageBloc>)

The new implementation provides:
- Better type safety
- Cleaner separation of concerns
- Resource state management with loading/error/success states
- Integration with ObjectBox for persistence
*/
