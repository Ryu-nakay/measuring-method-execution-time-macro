import Foundation

@attached(body)
public macro MeasureTime() = #externalMacro(module: "MeasuringMethodExecutionTimeMacros", type: "MeasureTimeMacro")

public struct MeasureTimeLogger {
    let startTime: Date

    public init() {
        self.startTime = Date.now
    }

    public func stop() {
        let endTime = Date.now
        let diff = Double(endTime.timeIntervalSince(startTime))
        let roundedDiff = round(diff * 1000_000_000) / 1000_000
        print("\(roundedDiff) ms")
    }
}
