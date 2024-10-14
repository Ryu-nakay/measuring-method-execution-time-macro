import MeasuringMethodExecutionTimeMacro

test()

@MeasureTime
func test() {
    print("Hello world")
}
