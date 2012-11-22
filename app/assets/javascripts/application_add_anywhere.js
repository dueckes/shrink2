$(document).ready(function() {
  $('body').click(function(event) {
    var closestLink = $(event.target).closest('a');
    if (closestLink && closestLink.hasClass('add_anywhere_link')) {
      closestLink.attr('href',
          new UrlBuilder(closestLink.data('url')).addParameter('clicked_container_dom_id', closestLink.closest('li').attr('id'))
                                                 .addParameter('position', UnorderedList.elementPosition(closestLink.closest('li')))
                                                 .build());
    }
  });
});
