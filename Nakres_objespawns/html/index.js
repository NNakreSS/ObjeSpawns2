$(document).ready(function(){
    var logs
$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }else if (item.action === "open") {
            // ReloadObjList(item.objdata)
            logs = item.objdata
        }
    })
    
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://Nakres_objespawns/exit', JSON.stringify({}));
            return
        }
    };

    $("#spawn").click(function () {
        let inputValue = $("#input").val()
        if (inputValue.length >= 100) {
            $.post("http://Nakres_objespawns/error", JSON.stringify({
                error: "Bu kadar uzun giremezsin"
            }))
            return
        } else if (!inputValue) {
            $.post("http://Nakres_objespawns/error", JSON.stringify({
                error: "Geçerli bir değer girmelisin"
            }))
            return
        }
        $.post('http://Nakres_objespawns/objectspawn', JSON.stringify({
            objname: inputValue,
        }));
        return;
    })

    $("#delete").click(function () {
        let inputValue = $("#input").val()
        if (inputValue.length >= 100) {
            $.post("http://Nakres_objespawns/error", JSON.stringify({
                error: "Bu kadar uzun giremezsin"
            }))
            return
        } else if (!inputValue) {
            $.post("http://Nakres_objespawns/error", JSON.stringify({
                error: "Geçerli bir değer girmelisin"
            }))
            return
        }
        $.post('http://Nakres_objespawns/deleteobj', JSON.stringify({
            objname: inputValue,
        }));
        return;
    })

    $("#saver").click(function () {
        document.getElementById("raconsal").innerHTML = "";
        $("#frame").css("display", "none");
        for (let i = 0; i < logs.length; i++) {
            console.log((logs[i]))
            var elem = '<div class="Option" data-myOutfit="'+(i + 1)+'"> <div class="DataHeader"><p>'+logs[i]+'</p></div><div class="SelectButton"><p>Spawn</p></div><div class="RemovetButton"><p>Delete</p></div></div>'
            $("#raconsal").append(elem);
            $("[data-myOutfit='"+(i + 1)+"']").data('myBtnData', logs[i])
        };
        $("#raconsal").css("display", "block");
    })
    $("#spawner").click(function () {
        $("#frame").css("display", "block");
        $("#raconsal").css("display", "none");
    })
})


$(document).on('click', '.SelectButton', function(e){
    e.preventDefault();

    var myBtnData = $(this).parent().data('myBtnData');
    $.post('https://Nakres_objespawns/SpawnObJson', JSON.stringify({
        name: myBtnData,
    }))
});

$(document).on('click', '.RemovetButton', function(e){
    e.preventDefault();
    var myBtnData = $(this).parent().data('myBtnData');
    $.post('https://Nakres_objespawns/DeleteObjSon', JSON.stringify({
        name: myBtnData,
    }));
});

// $("#raconsal").html("");
//  $.each(objelist, function(index, nk){
    //     console.log(index+" "+nk.name)
    //     var elem = '<div class="Option" data-myOutfit="'+(index + 1)+'"> <div class="DataHeader"><p>'+nk.name+'</p></div><div class="SelectButton"><p>Seç</p></div><div class="RemovetButton"><p>Sil</p></div></div>'
    //     $(".menujsonsaver").append(elem);
    // });
    // function ReloadObjList(objelist) {
        
    // };
    
    // $("#btn1").click(function(){
    //   $("p").append(" <b>Appended text</b>.");
    // });
    // $("#btn2").click(function(){
    //   $("ol").append("<li>Appended item</li>");
    // });
  });