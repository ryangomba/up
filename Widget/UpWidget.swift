import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let daysSince: DaysSince
}

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry

    func entryFor(date: Date) -> SimpleEntry {
        let daysSince = config.daysSince(now: date)
        return SimpleEntry(date: date, daysSince: daysSince)
    }

    // This is shown... when?
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            daysSince: DaysSince(completed: 13, progress: 0.75)
        )
    }

    // This is shown when the widget is previewed on the selection screen.
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(entryFor(date: Date()))
    }

    // TODO: what's a reasonable timeline?
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of 24 entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 24 {
            let date = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = entryFor(date: date)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

}

struct UpWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    @Environment(\.widgetRenderingMode) var renderingMode
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            ProgressView(
                daysSince: entry.daysSince,
                lineWidth: 8,
                backgroundLineScheme: .darkened,
                foregroundLineColor: Color.primary,
                font: .system(size: 48, weight: .bold)
            )
            .padding()
        case .accessoryCircular:
            switch renderingMode {
            case .vibrant:
                ProgressView(
                    daysSince: entry.daysSince,
                    lineWidth: 6,
                    backgroundLineScheme: .blurred,
                    foregroundLineColor: Color.primary,
                    font: .title
                )
            case .accented:
                ProgressView(
                    daysSince: entry.daysSince,
                    lineWidth: 4,
                    backgroundLineScheme: .darkened,
                    foregroundLineColor: Color.primary,
                    font: .title
                )
            case .fullColor:
                ProgressView(
                    daysSince: entry.daysSince,
                    lineWidth: 4,
                    backgroundLineScheme: .darkened,
                    foregroundLineColor: Color.green,
                    font: .title
                )
            default:
                fatalError("Unknown rendering mode")
            }
        default:
            Text("Erorr")
        }
    }
}

@main
struct UpWidget: Widget {
    let kind: String = Config.widgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            UpWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Counter")
        .description("Count up from a particular day.")
        #if os(iOS)
        .supportedFamilies([
            .systemSmall,
            .accessoryCircular,
        ])
        #else
        .supportedFamilies([
            .accessoryCircular,
        ])
        #endif
    }
}

struct UpWidget_Previews: PreviewProvider {
    static var previews: some View {
        #if os(iOS)
        ForEach(examples) { example in
            let entry = SimpleEntry(date: Date(), daysSince: example.daysSince)
            UpWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small: \(example.description)")
        }
        #endif
        ForEach(examples) { example in
            let entry = SimpleEntry(date: Date(), daysSince: example.daysSince)
            UpWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                .previewDisplayName("Circular: \(example.description)")
        }
    }
}
