import MeasuringMethodExecutionTimeMacro

Hoge().test()
Hoge.foo()
Fuga().test()
Fuga.foo()
Piyo.foo()

struct Hoge {
    @MeasureTime
    func test() {
        print("Hello world")
    }

    @MeasureTime
    static func foo() {
        print("Hello world")
    }
}

class Fuga {
    @MeasureTime
    func test() {
        print("Hello world")
    }

    @MeasureTime
    static func foo() {
        print("Hello world")
    }
}

enum Piyo {
    @MeasureTime
    static func foo() {
        print("Hello world")
    }
}
