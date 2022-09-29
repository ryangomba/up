import SwiftUI
import WidgetKit

enum BackgroundLineScheme: Int {
    case blurred = 1
    case darkened = 2
}

struct ProgressView: View {
    let daysSince: DaysSince
    let lineWidth: CGFloat
    let backgroundLineScheme: BackgroundLineScheme
    let foregroundLineColor: Color
    let font: Font

    var body: some View {
        ZStack {
            switch backgroundLineScheme {
            case .blurred:
                AccessoryWidgetBackground()
                    .clipShape(Circle().inset(by: lineWidth / 2).stroke(lineWidth: lineWidth))
            case .darkened:
                Circle()
                    .stroke(foregroundLineColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(lineWidth / 2)
                    .widgetAccentable()
                    .opacity(0.25)
            }
            Circle()
                .trim(from: 0, to: daysSince.progress)
                .stroke(foregroundLineColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(lineWidth / 2)
                .widgetAccentable()
            Text("\(daysSince.completed)")
                .font(font)
                .foregroundColor(.primary)
                .widgetAccentable()
        }
    }

}
