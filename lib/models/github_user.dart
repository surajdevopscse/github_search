class GitHubUser {
  const GitHubUser({
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
  });
  final String login;
  final String avatarUrl;
  final String htmlUrl;

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    final login = json['login'];
    if (login != null) {
      final avatarUrl = json['avatar_url'];
      final htmlUrl = json['html_url'];
      return GitHubUser(
        login: login,
        avatarUrl: avatarUrl,
        htmlUrl: htmlUrl,
      );
    }
    throw UnsupportedError('login is null');
  }

  @override
  String toString() => 'username: $login';
}
