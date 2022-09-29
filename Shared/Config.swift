import Foundation
import WidgetKit
import WatchConnectivity

struct DaysSince {
    let completed: Int
    let progress: Double
}

class Config: ObservableObject {
    static let widgetKind = "com.ryangomba.Up.Widget"
//    private static let defaults = UserDefaults(suiteName: "group.com.ryangomba.Up")!

    @Published var referenceDate: Date {
        didSet {
//            Self.defaults.set(referenceDate.timeIntervalSince1970, forKey: "timeIntervalSince1970")
            WidgetCenter.shared.reloadTimelines(ofKind: Config.widgetKind)
//            WCSession.default.transferUserInfo([
//                "timeIntervalSince1970": referenceDate.timeIntervalSince1970,
//            ])
        }
    }

    private static func getReferenceDate() -> Date {
        return Date(timeIntervalSince1970: 1670486400)
//        let savedInterval = defaults.double(forKey: "timeIntervalSince1970")
//        if savedInterval > 0 {
//            return Date(timeIntervalSince1970: savedInterval)
//        } else {
//            return Calendar.current.startOfDay(for: Date())
//        }
    }

    init() {
        self.referenceDate = Self.getReferenceDate()
    }

    public func daysSince(now: Date) -> DaysSince {
        let totalDays = now.timeIntervalSince(Self.getReferenceDate()) / (60 * 60 * 24)
        let completed = Int(floor(totalDays))
        let progress = totalDays - Double(completed)
        return DaysSince(
            completed: completed,
            progress: progress
        )
    }
}

let config = Config()

struct ExampleDaysSince: Identifiable {
    let daysSince: DaysSince
    let description: String
    var id: String {
        return description
    }
}

let examples: [ExampleDaysSince] = [
    ExampleDaysSince(
        daysSince: DaysSince(completed: 0, progress: 0.25),
        description: "Zero"
    ),
    ExampleDaysSince(
        daysSince: DaysSince(completed: 9, progress: 0.75),
        description: "Single"
    ),
    ExampleDaysSince(
        daysSince: DaysSince(completed: 34, progress: 0.75),
        description: "Double"
    ),
    ExampleDaysSince(
        daysSince: DaysSince(completed: 324, progress: 0.75),
        description: "Triple"
    ),
    ExampleDaysSince(
        daysSince: DaysSince(completed: 4096, progress: 0.75),
        description: "Quad"
    ),
]
