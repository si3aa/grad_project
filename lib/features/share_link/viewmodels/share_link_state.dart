abstract class ShareLinkState {
  const ShareLinkState();
}

class ShareLinkInitial extends ShareLinkState {
  const ShareLinkInitial();
}

class ShareLinkLoading extends ShareLinkState {
  const ShareLinkLoading();
}

class ShareLinkLoaded extends ShareLinkState {
  final String shareLink;
  const ShareLinkLoaded(this.shareLink);
}

class ShareLinkError extends ShareLinkState {
  final String message;
  const ShareLinkError(this.message);
}
