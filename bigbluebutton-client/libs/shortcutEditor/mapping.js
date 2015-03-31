var mappings = []; //enthält alle Mappings

//key ist der Schlüssel unter dem das Mapping im Localstorage gespeichert wird.
var key = "BigBlueButtonShortcutMapping";//diese Variable enthält den Localstorage key unter dem das mapping zu finden sein wird

//Keycodes bildet ASCII charcodes auf AS Keycodes ab
var KEYCODES = {
    27: 27, //esc
    96: 192, //`
    49: 49, //1
    50: 50, //2
    51: 51, //3
    52: 52, //4
    53: 53, //5
    54: 54, //6
    55: 55, //7
    56: 56, //8
    57: 57, //9
    48: 48, //0
    45: 189, //-
    61: 187, //=
    8: 8, //backspace
    9: 9, //tab
    113: 81, //q
    119: 87, //w
    101: 69, //e
    114: 82, //r
    116: 84, //t
    121: 89, //y
    117: 85, //u
    105: 73, //i
    111: 79, //o
    112: 80, //p
    91: 219, //[
    93: 221, //]
    92: 220, //\
    97: 65, //a
    115: 83, //s
    100: 68, //d
    102: 70, //f
    103: 71, //g
    104: 72, //h
    106: 74, //j
    107: 75, //k
    108: 76, //l
    59: 186, //;
    39: 222, //'
    13: 13, //enter
    122: 90, //z
    120: 88, //x
    99: 67, //c
    118: 86, //v
    98: 66, //b
    110: 78, //n
    109: 77, //m
    44: 188, //,
    46: 190, //.
    47: 191, ///
    32: 32, //space
    127: 46, //delete
    126: 192, //~
    33: 49, //!
    64: 50, //@
    35: 51, //#
    36: 52, //$
    37: 53, //%
    94: 54, //^
    38: 55, //&
    42: 56, //*
    40: 57, //(
    41: 48, //)
    95: 189, //_
    43: 187, //+
    81: 81, //Q
    87: 87, //W
    69: 69, //E
    82: 82, //R
    84: 84, //T
    89: 89, //Y
    85: 85, //U
    73: 73, //I
    79: 79, //O
    80: 80, //P
    123: 219, //{
    125: 221, //}
    124: 220, //|
    65: 65, //A
    83: 83, //S
    68: 68, //D
    70: 70, //F
    71: 71, //G
    72: 72, //H
    74: 74, //J
    75: 75, //K
    76: 76, //L
    58: 186, //:
    34: 222, //"
    90: 90, //Z
    88: 88, //X
    67: 67, //C
    86: 86, //V
    66: 66, //B
    78: 78, //N
    77: 77, //M
    60: 188, //<
    62: 190, //>
    63: 191     //?
};

mappingLineId=0;

//Diese Funktion kann KEYCODES Keys anhand ihres Wertes finden
function getKeysForValue(obj, value) {
    var all = [];
    for (var name in obj) {
        if (obj.hasOwnProperty(name) && obj[name] === value) {
            all.push(name);
        }
    }
    return all;
}

//Diese Funktion dient dazu, das Markup für eine Mappingline zu generieren
function createMappingline(original, to, action){
    var Line;
    //erzeuge ein span Objekt mit der Klasse mappingLine
    Line = $('<span/>',{'class':'mappingLine','id':'LineId'+String(mappingLineId)});
    //füge ein Text Objekt mit der Klasse action an
    Line.append($('<span/>',{'type':'text','class':'action','placeholder':'action','text':action}));
	Line.append(': ');
	//füge ein Text Objekt mit der Klasse original an
    Line.append($('<span/>',{'type':'text','class':'original','placeholder':'original','text':original}));
    Line.append(' = ');
    //fürge eien input (text) Objekt mit der Klasse new an
    Line.append($('<input/>',{'type':'text','class':'new','placeholder':'new','value':to}));
    Line.append($('<button/>',{'type':'button','text':'Zeile löschen','class':'killLine','onClick':"killMappingLine('#LineId"+String(mappingLineId)+"')"}));
    mappingLineId+=1;
    Line.append($('<br/>'));
    return Line;
}

function findMappedItem(keycode, mapping) {
	for (attribute in mappings) {
		var beginning = element.original.substring(element.original.lastIndexOf('+') + 1);
		if (beginning === keycode)
			return mappings[attribute];
	}
}

//Löschen einer Mappingzeile
function killMappingLine(Id){
    $(Id).remove();
}

$(document).ready(function () {
    //diese Funktionen können die Nutzer und Dev infos per Klassen hinzufügen und CSS anzeigen und ausblenden
    $("#NutzerhilfeAnzeigen").click(function () {
        if ($('#userinfo').hasClass('hide')) {
            $('#userinfo').removeClass('hide');
            $("#NutzerhilfeAnzeigen").text('Nutzerhilfe ausblenden');
        } else {
            $('#userinfo').addClass('hide');
            $("#NutzerhilfeAnzeigen").text('Nutzerhilfe anzeigen');
        }
    });
    $("#DevelopersInfoAnzeigen").click(function () {
        if ($('#devinfo').hasClass('hide')) {
            $('#devinfo').removeClass('hide');
            $("#DeelopersInfoAnzeigen").text('Developerinfos ausblenden');
        } else {
            $('#devinfo').addClass('hide');
            $("#DevelopersInfoAnzeigen").text('Developerinfos anzeigen');
        }
    });
    
    //Hinzufügen einer Mappinzeile
    $("button#addMappingLine").click(function () {
        //Eine Mappingline wird an das Ende der entsprechenden Form angehängt
        $("form#mappingLines").append(createMappingline('',''));
    });
	
	

    //Ausgeben und Speichern
    $("button#generateJSONOutputAndSave").click(function () {
        //Für jede Zeile im Mapping
        $(".mappingLine").each(function () {
            //finde die Eingabe von Original
            var original = $(this).find("span.original").text();
            var to = $(this).find("input").val();
            //Wenn original nur 1 Zeichen lang ist
            if (original.length === 1 && to.length === 1) {
				var mappingItem =  findMappedItem(KEYCODES[original.charCodeAt(0)], mappings);
                //convertiere den Charcode in einen ASKeycode
				mappingItem.custom =  mappingItem.custom.substring(0, mappingItem.custom.lastIndexOf('+') + 1) + KEYCODES[to.charCodeAt(0)];
				// verändere die Mapping Belegung
				mapping[mappingItem.original] = mappingItem;
            } else {
                //Falls die Eingabe länger als ein Zeichen sind melde den Fehler und überspringe die Zeile
                alert("In der Zeile " + original + " = " + to + " ist ein Fehler aufgetreten. Die Eingabe ist mehr als ein Zeichen lang");
                return;
            }
        });
        //Mache aus Mappings ein JSON String um sie anzuzeigen.
        var json = JSON.stringify(mappings);
        //Zeige das ergebnis an
        $("p#JSONOutput").text(json);
        //Speichere es im Localstorage zur wiederverwertung durch BigBlueButton
        localStorage.setItem(key, json);
        //Zeige an, dass die Aktion erfolgreich war.
        //alert("added " + json + " to localstorage with key: " + key);

    });

    //Momentane Einstellungen zum bearbeiten in die Konfigurationsansicht laden.
    $("button#loadCurrentConfig").click(function () {
        //Lade den JSON String aus dem Localstorage
        var json = localStorage.getItem(key);
        //Parse ihn und speichere das Ergebnis in mappings
        mappings = JSON.parse(json);
        //zeige den JSON String in der Ausgabe an.
        $("p#JSONOutput").text(json);
        //Vorhandene Zeilen löschen
        $("form#mappingLines").html("");
        //Für jedes Mapping
        for (attribute in mappings) {
			var element = mappings[attribute];
            //Füge eine Mappingzeile in die Form eine die bereits die geladenen Daten enthält
			var original = parseInt(element.original.substring(element.original.lastIndexOf('+') + 1));
			var to = parseInt(element.custom.substring(element.custom.lastIndexOf('+') + 1));
            original = getKeysForValue(KEYCODES, original)[0];
            to = getKeysForValue(KEYCODES, to)[0];
            $("form#mappingLines").append(createMappingline(String.fromCharCode(original),String.fromCharCode(to), element.action));
        }
    });
    //Mit dieser Funktion können Backups eingespielt werden.
    $("button#loadBackup").click(function () {
        //Speichere die Daten aus dem Textfeld im Localstorage
        localStorage.setItem(key, $("input#backuploader").val());
        //löse ein Event, aus, dass LoadCurrentConfig starten lässt.
        $("button#loadCurrentConfig").click();
    });
});