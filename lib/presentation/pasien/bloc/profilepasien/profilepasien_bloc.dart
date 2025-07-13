import 'package:finalproject/data/repository/pasien_profile_repository.dart';
import 'package:finalproject/presentation/pasien/bloc/profilepasien/profilepasien_event.dart';
import 'package:finalproject/presentation/pasien/bloc/profilepasien/profilepasien_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasienProfileBloc extends Bloc<PasienProfileEvent, PasienProfileState> {
  final PasienProfileRepository pasienProfileRepository;

  PasienProfileBloc({required this.pasienProfileRepository}) : super(PasienProfileInitial()) {
    // Register event handlers
    on<GetPasienProfileEvent>(_onGetPasienProfile);
    on<CreatePasienProfileEvent>(_onCreatePasienProfile);
    on<UpdatePasienProfileEvent>(_onUpdatePasienProfile);
    on<DeletePasienProfileEvent>(_onDeletePasienProfile);
  }

  /// Handles the GetPasienProfileEvent to fetch patient profile.
  Future<void> _onGetPasienProfile(GetPasienProfileEvent event, Emitter<PasienProfileState> emit) async {
    emit(PasienProfileLoading()); // Emit loading state
    try {
      final profile = await pasienProfileRepository.getAuthenticatedPasienProfile(event.token);
      emit(PasienProfileLoaded(profile)); // Emit loaded state with profile data
    } catch (e) {
      emit(PasienProfileError(e.toString())); // Emit error state
    }
  }

  /// Handles the CreatePasienProfileEvent to create a new patient profile.
  Future<void> _onCreatePasienProfile(CreatePasienProfileEvent event, Emitter<PasienProfileState> emit) async {
    emit(PasienProfileLoading()); // Emit loading state
    try {
      final response = await pasienProfileRepository.createAuthenticatedPasienProfile(event.token, event.requestModel);
      emit(PasienProfileCreated(response)); // Emit created state with response
    } catch (e) {
      emit(PasienProfileError(e.toString())); // Emit error state
    }
  }

  /// Handles the UpdatePasienProfileEvent to update an existing patient profile.
  Future<void> _onUpdatePasienProfile(UpdatePasienProfileEvent event, Emitter<PasienProfileState> emit) async {
    emit(PasienProfileLoading()); // Emit loading state
    try {
      final response = await pasienProfileRepository.updateAuthenticatedPasienProfile(event.token, event.requestModel);
      emit(PasienProfileUpdated(response)); // Emit updated state with response
    } catch (e) {
      emit(PasienProfileError(e.toString())); // Emit error state
    }
  }

  /// Handles the DeletePasienProfileEvent to delete a patient profile.
  Future<void> _onDeletePasienProfile(DeletePasienProfileEvent event, Emitter<PasienProfileState> emit) async {
    emit(PasienProfileLoading()); // Emit loading state
    try {
      await pasienProfileRepository.deleteAuthenticatedPasienProfile(event.token);
      emit(const PasienProfileDeleted('Profil pasien berhasil dihapus.')); // Emit deleted state
    } catch (e) {
      emit(PasienProfileError(e.toString())); // Emit error state
    }
  }
}
