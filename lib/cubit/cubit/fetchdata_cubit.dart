import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_tracker/cubit/cubit/fetchdata_state.dart';
import 'package:sleep_tracker/local_storage.dart';

class FetchdataCubit extends Cubit<FetchdataState> {
  final LocalStorage _localStorage;

  FetchdataCubit(this._localStorage) : super(FetchdataInitial()) {
    _initializeAndFetch();
  }

  Future<void> _initializeAndFetch() async {
    await _localStorage.initializeData();
    fetchData();
  }

  void fetchData() {
    emit(FetchdataLoading());

    final data = _localStorage.getAllValues();

    if (data.isNotEmpty) {
      emit(Fetchdatasuccess(data: data));
    } else {
      emit(Fetchdatafailed());
    }
  }
}
