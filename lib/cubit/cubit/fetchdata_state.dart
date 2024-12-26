sealed class FetchdataState {}

final class FetchdataInitial extends FetchdataState {}

final class FetchdataLoading extends FetchdataState{}

final class Fetchdatafailed extends FetchdataState{}

final class Fetchdatasuccess extends FetchdataState{
  final List<Map<String,dynamic>> data;

  Fetchdatasuccess({required this.data});

}
