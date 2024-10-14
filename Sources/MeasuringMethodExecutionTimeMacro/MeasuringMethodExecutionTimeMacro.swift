import Foundation

@attached(memberAttribute)
public macro TimeMeasureable() = #externalMacro(module: "MeasuringMethodExecutionTimeMacros", type: "TimeMeasureableMacro")

/// - Warning: Cannot be attached to  global function.
@attached(body)
public macro MeasureTime() = #externalMacro(module: "MeasuringMethodExecutionTimeMacros", type: "MeasureTimeMacro")

public struct MeasureTimeLogger {
    let startTime: Date

    public init() {
        self.startTime = Date.now
    }

    public func stop(className: String, functionName: String = #function) {
        let endTime = Date.now
        let diff = Double(endTime.timeIntervalSince(startTime))
        let roundedDiff = round(diff * 1000_000_000) / 1000_000
        print("📝 \(className).\(functionName) / ⏱️ \(roundedDiff) ms")
    }
}
