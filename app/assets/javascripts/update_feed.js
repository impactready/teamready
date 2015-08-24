$(function() {
    $('select#category_group_object').change(function () {
        var object_class = $(this).val();
        var update_items = $('div.group_tab').filter(':visible').find('div.update-item');

        update_items.hide();
        update_items.filter(function () {
            return $(this).data('updatable-type') === object_class
        }).show();
        $('html, body').animate({
               scrollTop: $('div[data-group-section-id="update-feed"]').offset().top
        }, 50);
    });

    $('div.group-section-link').click(function () {
        section = $(this).data('group-section-id');
        current_group_tab = $('div.group_tab').filter(':visible');
        current_group_tab.find('div.group-section').hide();
        current_group_tab.find('div#group-section-' + section).show()
        $('html, body').animate({
               scrollTop: $(this).offset().top
        }, 50);
    });
});