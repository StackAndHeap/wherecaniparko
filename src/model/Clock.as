package model {
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

public class Clock {

    public static const TIMES_UP:String = "timesUp";

    [Bindable]
    public var timeString:String;

    [Bindable]
    public var isRunning:Boolean;

    private var _timer:Timer;
    private var _initialTimeInSeconds:uint;
    private var _timeInSeconds:uint;

    public function Clock(timeInSeconds:uint) {
        _initialTimeInSeconds = _timeInSeconds = timeInSeconds;

        timeString = TimeUtil.convertToHHMMSS(_timeInSeconds);
    }

    public function start():void {
        startTimer();
    }

    public function reset():void {
        if (_timer && _timer.running) {
            _timer.stop();
            isRunning = false;
        }

        _timeInSeconds = _initialTimeInSeconds;
    }

    private function startTimer():void {
        _timer = new Timer(1000);
        _timer.addEventListener(TimerEvent.TIMER, timer_timerHandler);
        _timer.addEventListener(TimerEvent.TIMER_COMPLETE, timer_timerCompleteHandler);
        _timer.start();

        isRunning = true;
    }


    private function timer_timerHandler(event:TimerEvent):void {
        _timeInSeconds--;
        timeString = TimeUtil.convertToHHMMSS(_timeInSeconds);

        if (_timeInSeconds == 0) {
            _timer.stop();
            isRunning = false;
        }
    }

    private function timer_timerCompleteHandler(event:TimerEvent):void {
        dispatchEvent(new Event(TIMES_UP));
    }
}
}
