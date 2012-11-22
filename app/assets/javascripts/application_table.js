var Table = $.klass({
  initialize: function(tableSelector) {
    this._table = $(tableSelector);
  },
  row: function(rowPosition) {
    var rowElement = this._table.find('tr')[rowPosition];
    return $(rowElement);
  },
  cell: function(rowPosition, cellPosition) {
    var rowObject = this.row(rowPosition);
    var cellElement = rowObject.find('td, th')[cellPosition];
    return $(cellElement);
  },
  rowPosition: function(rowSelector) {
    return $(rowSelector).positionInParent();
  },
  columnPosition: function(cellSelector) {
    return $(cellSelector).positionInParent();
  },
  numberOfRows: function() {
    return this._table.find('tr').length;
  },
  numberOfColumns: function() {
    return this.row(0).find('th,td').length;
  },
  removeRow: function(rowPosition) {
    this.row(rowPosition).remove();
  },
  removeColumn: function(columnPosition) {
    this._table.find('tr').each(function(i, rowElement) {
      var cellElement = $(rowElement).find('th, td')[columnPosition];
      $(cellElement).remove();
    });
  }
});

$(document).ready(function() {
  $('body').click(function(event) {
    var closestLink = $(event.target).closest('a');
    if (closestLink && closestLink.hasClass('table_link')) {
      var table = new Table('#' + closestLink.closest('form').attr('id'));
      var urlBuilder = new UrlBuilder(closestLink.data('url'));
      if (closestLink.hasClass('add_column')) {
        urlBuilder.addParameter('position', table.columnPosition('#' + closestLink.closest('td').attr('id')))
                  .addParameter('number_of_rows', table.numberOfRows());
      } else if (closestLink.hasClass('remove_column')) {
        urlBuilder.addParameter('position', table.columnPosition('#' + closestLink.closest('td').attr('id')));
      } else if (closestLink.hasClass('add_row')) {
        urlBuilder.addParameter('position', table.rowPosition('#' + closestLink.closest('tr').attr('id')))
                  .addParameter('number_of_columns', table.numberOfColumns());
      } else if (closestLink.hasClass('remove_row')) {
        urlBuilder.addParameter('position', table.rowPosition('#' + closestLink.closest('tr').attr('id')));
      }
      closestLink.attr('href', urlBuilder.build());
    }
  });
});
