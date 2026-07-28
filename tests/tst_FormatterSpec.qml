import QtQuick 2.6
import QtTest 1.2
import "../qml/logic/pipboyFormatter.js" as Fmt

TestCase {
    name: "FormatterSpec"

    function test_two() {
        compare(Fmt.two(4), "04");
        compare(Fmt.two(14), "14");
    }

    function test_date() {
        var d = new Date(2026, 4, 17);
        compare(Fmt.dateDDMMYYYY(d), "17/05/2026");
    }

    function test_time24() {
        var d = new Date(2026, 4, 17, 9, 5, 7);
        compare(Fmt.time24(d, false), "09:05");
        compare(Fmt.time24(d, true), "09:05:07");
    }
}
