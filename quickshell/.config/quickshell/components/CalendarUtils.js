.pragma library

var weekDayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

function startOfWeek(date) {
    const day = date.getDay();
    const diff = (day === 0 ? -6 : 1) - day;
    return new Date(date.getFullYear(), date.getMonth(), date.getDate() + diff);
}

function weekDates() {
    const monday = startOfWeek(new Date());
    const days = [];
    for (let i = 0; i < 7; i++)
        days.push(new Date(monday.getFullYear(), monday.getMonth(), monday.getDate() + i));
    return days;
}

function isSameDay(a, b) {
    return a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate();
}

function weekLabel() {
    const days = weekDates();
    const first = days[0];
    const last = days[6];

    if (first.getFullYear() === last.getFullYear()) {
        if (first.getMonth() === last.getMonth())
            return monthNames[first.getMonth()] + " " + first.getFullYear();
        return monthNames[first.getMonth()] + " - " + monthNames[last.getMonth()] + " " + first.getFullYear();
    }
    return monthNames[first.getMonth()] + " " + first.getFullYear() + " - " + monthNames[last.getMonth()] + " " + last.getFullYear();
}

function monthGrid(year, month) {
    const first = new Date(year, month, 1);
    const startOffset = (first.getDay() + 6) % 7;
    const daysInMonth = new Date(year, month + 1, 0).getDate();

    const cells = [];
    for (let i = 0; i < startOffset; i++)
        cells.push(0);
    for (let d = 1; d <= daysInMonth; d++)
        cells.push(d);
    while (cells.length % 7 !== 0)
        cells.push(0);

    const weeks = [];
    for (let i = 0; i < cells.length; i += 7)
        weeks.push(cells.slice(i, i + 7));
    return weeks;
}
