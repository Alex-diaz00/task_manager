class PaginatedResponse<T> {
  final List<T> items;
  final PaginationMeta meta;
  final PaginationLinks links;

  const PaginatedResponse({
    required this.items,
    required this.meta,
    required this.links,
  });
}

class PaginationMeta {
  final int itemCount;
  final int totalItems;
  final int itemsPerPage;
  final int totalPages;
  final int currentPage;

  PaginationMeta({
    required this.itemCount,
    required this.totalItems,
    required this.itemsPerPage,
    required this.totalPages,
    required this.currentPage,
  });
}

class PaginationLinks {
  final String first;
  final String? next;
  final String last;

  PaginationLinks({required this.first, this.next, required this.last});
}
