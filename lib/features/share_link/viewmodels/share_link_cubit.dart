import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/share_link_repository.dart';
import 'share_link_state.dart';

class ShareLinkCubit extends Cubit<ShareLinkState> {
  final ShareLinkRepository repository;
  ShareLinkCubit(this.repository) : super(ShareLinkInitial());

  Future<void> generateShareLink(int productId) async {
    emit(ShareLinkLoading());
    final link = await repository.getShareLink(productId);
    if (link != null) {
      emit(ShareLinkLoaded(link));
    } else {
      emit(ShareLinkError('Failed to generate share link'));
    }
  }
}
