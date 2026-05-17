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
}
