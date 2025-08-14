function setAdultTickets(adultTicketsWanted) {
    const adultTicketsCount = parseInt($('.quantity-control.row > input')[0].value, 10);
    const ticketChangeIterations = Math.abs(adultTicketsWanted - adultTicketsCount);
    const ticketChangeButton = $(`.quantity-control.row > button.typcn-${adultTicketsCount < adultTicketsWanted ? 'plus' : 'minus'}`)[0];

    for (let i = 0; i < ticketChangeIterations; i++) {
        ticketChangeButton.click();
    }
}

function playSound(src) {
    return new Promise((resolve) => {
        const audio = new Audio(src);
        audio.onended = resolve;
        audio.play();
    });
}

function repeatHeyListen() {
    playSound('https://www.myinstants.com/media/sounds/hey_listen.mp3')
        .then(repeatHeyListen);
}

function waitForAvailability(monthWanted) {
    return new Promise((resolve) => {
        setTimeout(() => {
            const availableEls = $('.calendar>.row:not(.blankLoader) .calendar-body .day.available'), isLoading = $('.calendar-modal[data-component=eventTimeModal] .modal-content > .loading-mask.hide').length === 0;
            if (isLoading) {
                return waitForAvailability(monthWanted)
                    .then((res) => resolve(res));
            }

            if (monthWanted == null) {
                resolve({ availableEls });
            }

            const monthValue = $('[name="ctl00$ContentPlaceHolder$SalesChannelDetailControl$EventsDateTimeSelectorModal$EventsDateTimeSelector$CalendarSelector$MonthDropDownList"]')[0].value;
            const month = parseInt(monthValue.replace(/^\D+/g, ''), 10);

            if (month < monthWanted) {
                console.log(`Month too early (${month}) - skipping to next month.`);
                $('[name="ctl00$ContentPlaceHolder$SalesChannelDetailControl$EventsDateTimeSelectorModal$EventsDateTimeSelector$CalendarSelector$NextMonthImageButton"]').click();
                return waitForAvailability(monthWanted).then(res => resolve(res));
            }

            resolve({ availableEls, month });
        }, 1000);
    });
}

function playSounds() {
    playSound('https://www.myinstants.com/media/sounds/mlg-airhorn.mp3')
        .then(() => playSound('https://www.myinstants.com/media/sounds/sound-9______.mp3'))
        .then(() => playSound('https://www.myinstants.com/media/sounds/ps_1.mp3'))
        .then(() => playSound('https://www.myinstants.com/media/sounds/wrong-answer-sound-effect.mp3'))
        .then(() => playSound('https://www.myinstants.com/media/sounds/lalalalala.swf.mp3'))
        .then(() => playSound('https://www.myinstants.com/media/sounds/tuturu_1.mp3'))
        .then(() => playSound('https://www.myinstants.com/media/sounds/hallelujahshort.swf.mp3'))
        .then(repeatHeyListen);
}

async function addTicketsToBasket(dayElement) {
    dayElement.click();

    await new Promise((resolve) => setTimeout(resolve, 2000));
    await waitForAvailability();

    const chooseTimeButton = $('.ui-control.button.select-time:not(.disabled)')[0];
    if (!chooseTimeButton) return false;

    console.log('Found tickets!!!!!');
    playSounds();

    chooseTimeButton.click();

    await new Promise((resolve) => setTimeout(resolve, 2000));

    $('.typcn.typcn-shopping-cart.ng-binding')[0].click();
    return true;
}

function checkForTickets(datesWanted=[6, 7, 8], adultTicketsWanted=2, checkFrequency=15, monthWanted) {
    setAdultTickets(adultTicketsWanted);

    async function check() {
        if ($('.ui-control.button.extendSession').length != 0) {
            console.log('Extending session');
            $('.ui-control.button.extendSession').click();
        }

        $('.shared-calendar-button').click();

        waitForAvailability(monthWanted)
            .then(async ({ availableEls, month }) => {
                console.log(new Date(), `Availability loaded${month != null ? ` for month ${month}` : ''}. Checking for relevant dates...`);

                if (monthWanted != null && month > monthWanted) {
                    console.log(`Month is too late (${month}). Will check again in ${checkFrequency} seconds.`);
                    setTimeout(check, checkFrequency * 1000);
                    return;
                }

                for (let i = 0; i < availableEls.length; i++) {
                    const day = parseInt($('.calendar>.row:not(.blankLoader) .calendar-body .day.available')[i].innerText, 10);
                    console.log('Day', day, 'is available...');
                    if (datesWanted.includes(day)) {
                        const succeeded = await addTicketsToBasket($('.calendar>.row:not(.blankLoader) .calendar-body .day.available')[i]);
                        if (succeeded) return;
                    }
                }

                console.log(`Relevant dates not yet available. Will check again in ${checkFrequency} seconds.`);
                setTimeout(check, checkFrequency * 1000);
            });
    };
    check();
}

function checkForTicketsInMonth(datesWanted, monthWanted, adultTicketsWanted, checkFrequency) {
    return checkForTickets(datesWanted, adultTicketsWanted, checkFrequency, monthWanted);
}