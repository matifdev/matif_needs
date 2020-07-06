let isShowed = false


window.addEventListener('message', function (event) {

	switch (event.data.action) {
        case 'showMiddleText':
            saferInnerHTML(document.querySelector('#middle-text'), event.data.text)
            $('#middle-text').animate({
                opacity: "1.0"
            }, 850)
            break
        case 'updateMiddleText':
            saferInnerHTML(document.querySelector('#middle-text'), event.data.text)
            break
        case 'hideMiddleText':
            $('#middle-text').animate({
                opacity: "0.0"
            }, 850)
            break 
        case 'showTopText':
            saferInnerHTML(document.querySelector('#top-text'), event.data.text)
            $('#top-text').animate({
                opacity: "1.0"
            }, 700)
            break
        case 'hideTopText':
            $('#top-text').animate({
                opacity: "0.0"
            }, 700)
            break
             
    }
});
