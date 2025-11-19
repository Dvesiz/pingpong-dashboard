/* ==========================
 *  pingpong-dashboard
 *  仅保留：rem 适配 + loading 关闭
 * ========================== */
$(document).ready(function () {
    var whei = $(window).width();
    $("html").css({fontSize: whei / 20});
    $(window).resize(function () {
        var whei = $(window).width();
        $("html").css({fontSize: whei / 20});
    });
});

$(window).on("load", function () {
    $(".loading").fadeOut();
});
