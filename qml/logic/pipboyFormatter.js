.pragma library

function two(v) {
    return (v < 10 ? "0" : "") + v;
}

function dateDDMMYYYY(d) {
    return two(d.getDate()) + "/" + two(d.getMonth() + 1) + "/" + d.getFullYear();
}

function time24(d, showSeconds) {
    var out = two(d.getHours()) + ":" + two(d.getMinutes());
    if (showSeconds) {
        out += ":" + two(d.getSeconds());
    }
    return out;
}

function dayOfYear(d) {
    var start = new Date(d.getFullYear(), 0, 0);
    var diff = d - start;
    return Math.floor(diff / 86400000);
}

function weekOfYear(d) {
    var date = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
    var dayNum = date.getUTCDay() || 7;
    date.setUTCDate(date.getUTCDate() + 4 - dayNum);
    var yearStart = new Date(Date.UTC(date.getUTCFullYear(), 0, 1));
    return Math.ceil((((date - yearStart) / 86400000) + 1) / 7);
}

function moonPhaseIndex(d) {
    var year = d.getUTCFullYear();
    var month = d.getUTCMonth() + 1;
    var day = d.getUTCDate();
    if (month < 3) {
        year--;
        month += 12;
    }
    month++;
    var c = 365.25 * year;
    var e = 30.6 * month;
    var jd = c + e + day - 694039.09;
    jd /= 29.5305882;
    var b = Math.floor(jd);
    jd -= b;
    b = Math.round(jd * 8);
    if (b >= 8) {
        b = 0;
    }
    return b;
}

function moonPhaseName(index) {
    var names = [
        "New", "Wax Cres", "First Q", "Wax Gibb",
        "Full", "Wan Gibb", "Last Q", "Wan Cres"
    ];
    return names[index] || "Unknown";
}

