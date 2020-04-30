$(function() {
    window.onload = (e) => {
        window.addEventListener('message', (event) => {
            var item = event.data;

            if (item === undefined) return;
            if (item.type !== "pixelated.radio") return;

            if (item.display) {
                $("#radio").show();
            } else if (item.display === false) {
                $("#radio").hide();
            }

            if (item.text !== undefined && item.text.length > 0) {
                $("#display h1").text(item.text)
            }
        });
    }
});