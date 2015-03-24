var mappings = []; //enthält alle Mappings
var key = "BigBlueButtonShortcutMapping";//diese Variable enthält den Localstorage key unter dem das mapping zu finden sein wird
$(document).ready(function () {
    $("button#addMappingLine").click(function () {
        var mappingLine = '<span class="mappingLine"><input type="text" class="original"> = <input type="text" class="new"></span><br />';
        $("form#mappingLines").append(mappingLine);
    });
    $("button#generateJSONOutputAndSave").click(function () {
        $(".mappingLine").each(function () {
            var pair = {
                "original": $(this).children("input.original").val(),
                "new": $(this).children("input.new").val()
            };
            mappings.push(pair);
        });
        var json = JSON.stringify(mappings);
        $("p#JSONOutput").text(json);
        localStorage.setItem(key, json);
        alert("added " + json + " to localstorage with key: " + key);

    });
    $("button#loadCurrentConfig").click(function () {
        json = localStorage.getItem(key);
        mappings = JSON.parse(json);
        $("p#JSONOutput").text(json);
        mappings.forEach(function (element, index, array) {
            var mappingLine = '<span class="mappingLine"><input type="text" class="original" value="'+element.original+'"> = <input type="text" class="new" value="'+element.new+'"></span><br />';
            $("form#mappingLines").append(mappingLine);
        });
    });

    //abandoned Functionality
    $("button#generateJSONOutput").click(function () {
        $(".mappingLine").each(function () {
            var pair = {
                "original": $(this).children("input.original").val(),
                "new": $(this).children("input.new").val()
            };
            mappings.push(pair);
        });
        $("p#JSONOutput").html(JSON.stringify(mappings));
    });
    $("button#addToLocalstorage").click(function () {
        localStorage.setItem(key, JSON.stringify(mappings));
        alert(JSON.stringify(mappings) + " wurde zum localstorage unter den Schlüssel: " + key + " hinzugefügt.");
    });
    $("button#checkLocalstorage").click(function () {
        alert(localStorage.getItem(key));
    });
});
