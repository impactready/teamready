$(function() {
    if ($('select#category_group_object').val() !== "") {
        $('li#category_submit_action button').show();
    }

    $('select#category_group_object').change(function () {
        var object_class = $(this).val();
        var update_items = $('div.group_tab').filter(':visible').find('div.update-item');
        if (object_class !== "") {

            update_items.hide();
            update_items.filter(function () {
                return $(this).data('updatable-type') === object_class
            }).show();
            $('html, body').animate({
                   scrollTop: $('div[data-group-section-id="update-feed"]').offset().top
            }, 50);
            $('li#category_submit_action button').show();
        } else {
            update_items.show();
            $('li#category_submit_action button').hide();
        }
    });

    $('div.group-section-link').click(function () {
        section = $(this).data('group-section-id');
        $('div.group-section-link').find(".expand").html("expand &darr;")
        $(this).find(".expand").html("")
        current_group_tab = $('div.group_tab').filter(':visible');
        current_group_tab.find('div.group-section').hide();
        current_group_tab.find('div#group-section-' + section).show()
        // $('html, body').animate({
        //        scrollTop: $(this).offset().top - 50
        // }, 50);
    });

    $('div.group-section-link').hover(function() {
        $(this).find(".expand").show();
    }, function() {
        $(this).find(".expand").hide();
    })
});