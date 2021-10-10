class Issue {
  final String title;
  final String content;
  String status;

  String address;
  String latitude;
  String longitude;
  List<String> photos;
  List<String> tags;

  static final Map<String, String> backendFrontendValueMap = {
    'CREATED': 'в обработке',
    'IN_PROGRESS': 'в обработке',
    'COMPLETED': 'выполнено'
  };

  Issue({
    this.title,
    this.content,
    this.status = "в обработке",
  }) {
    this.status = backendFrontendValueMap[this.status];
  }
}
