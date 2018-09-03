class Page<T> {
  int pageNum;
  int pageSize;
  int totalCount;
  List<T> contentResults;

  @override
  String toString() {
    return 'Page{pageNum: $pageNum, pageSize: $pageSize, totalCount: $totalCount, '
        'contentResults: $contentResults}';
  }
}
