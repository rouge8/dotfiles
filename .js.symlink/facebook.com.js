jQuery(document).ready(function($) {
    var MutationObserver = window.MutationObserver || window.WebKitMutationObserver;

    function getParameterByName(url, name) {
      name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
      var regexS = "[\\?&]" + name + "=([^&#]*)";
      var regex = new RegExp(regexS);
      var results = regex.exec(url);
      if (results === null)
        return "";
      else
        return decodeURIComponent(results[1].replace(/\+/g, " "));
    }

    function animate(gifs) {
        gifs.each(function() {
            var $this = $(this),
                $parent = $this.parent(),
                src = $this.attr('src'),
                url = getParameterByName(src, 'url'),
                height = $parent.height(),
                width = $parent.width();
            $this.attr('src', url);

            // make gifs as big as possible :)
            if (height || width) {
                if (height > width) {
                    $this.css('width', 'auto')
                         .height(height);
                } else if (width > height) {
                    $this.css('height', 'auto')
                         .width(width);
                }
                else {
                    $this.css('max-height', height + 'px')
                         .css('max-width', width + 'px')
                         .css('height', 'auto')
                         .css('width', 'auto');
                }
            }
        });
    }

    var observer = new MutationObserver(function(mutations, observer) {
        var safeImageGifs = $('a img[src*="safe_image.php"][src$=".gif"]');
        animate(safeImageGifs);

        var backgroundGifs = $('img.shareMediaPhoto').filter(function() {
            var image = $(this).css('background-image');
            return image.indexOf('.gif') > -1 && image.indexOf('safe_image.php') > -1;
        });
        backgroundGifs.each(function() {
            var $this = $(this),
                url = $(this).css('background-image');
            url = url.slice(4, url.length - 1);
            $this.css('background-image', '');
            $this.attr('src', url);
        });
        animate(backgroundGifs);
    });

    observer.observe(document, {
        subtree: true,
        attributes: true
    });
});
