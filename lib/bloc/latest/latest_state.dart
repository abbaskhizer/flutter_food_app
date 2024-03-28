part of 'latest_bloc.dart';

@immutable
abstract class LatestState {}

final class LatestInitialState extends LatestState {}

final class LatestLoadingState extends LatestState {}

final class LatestLoadedState extends LatestState {
  final Stream data;

  LatestLoadedState({required this.data});
}
