import MeasuringMethodExecutionTimeMacro

Hoge().test()
Hoge.foo()
Fuga().test()
Fuga.foo()
Piyo.foo()

@TimeMeasureable
struct Hoge {
    let a = 0

    func test() {
        print("Hello world")
    }

    @discardableResult
    static func foo() -> String {
        return "Hello world"
    }
}

@TimeMeasureable
class Fuga {
    func test() {
        print("Hello world")
    }

    @discardableResult
    static func foo() -> String {
        return "Hello world"
    }
}

@TimeMeasureable
enum Piyo {
    @discardableResult
    static func foo() -> String {
        return "Hello world"
    }
}
