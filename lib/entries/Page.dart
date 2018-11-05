class Page<T> {
  int pageNum;
  int pageSize;
  int totalCount;
  List<T> contentResults;

  int getTotalPages(){
    if (totalCount == null || totalCount == 0) {
      return 0;
    } else {
      int more = totalCount % pageSize;
      int totalPage = totalCount ~/ pageSize;
      if (more > 0) {
        totalPage++;
      }
      return totalPage;
    }
  }

  @override
  String toString() {
    return 'Page{pageNum: $pageNum, pageSize: $pageSize, totalCount: $totalCount, '
        'contentResults: $contentResults}';
  }
}
