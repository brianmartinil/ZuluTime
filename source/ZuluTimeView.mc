using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class ZuluTimeView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours == 0) {
                hours = 12;
            } else if (hours > 12) {
                hours = hours - 12;
            }
        }

        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
        var view = (View.findDrawableById("TimeLabel") as Toybox.WatchUi.Text);
        view.setText(timeString);

        var utc = Gregorian.utcInfo(Time.now(), Time.FORMAT_MEDIUM);

        var zulu = (View.findDrawableById("ZuluLabel") as Toybox.WatchUi.Text);
        zulu.setText(Lang.format("$1$$2$Z", [utc.hour.format("%02d"), utc.min.format("%02d")]));

        var local = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateLabel = (View.findDrawableById("DateLabel") as Toybox.WatchUi.Text);
        dateLabel.setText(Lang.format("$1$ $2$", [local.month, local.day.format("%02d")]));

        var bluetoothLabel = (View.findDrawableById("BluetoothLabel") as Toybox.WatchUi.Text);

        if (System.getDeviceSettings().phoneConnected) {
            bluetoothLabel.setText("B");
        } else {
           bluetoothLabel.setText("");
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        var batteryLevel = System.getSystemStats().battery;
        var battColor = Graphics.COLOR_WHITE;

        if (batteryLevel < 20.0) {
            battColor = Graphics.COLOR_RED;
        }

        dc.setColor(battColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(122, 5, (batteryLevel / 100.0) * 20, 9);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
