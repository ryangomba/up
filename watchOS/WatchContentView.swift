import SwiftUI

struct WatchContentView: View {
    let daysSince: DaysSince
    var body: some View {
        ProgressView(
            daysSince: daysSince,
            lineWidth: 10,
            backgroundLineScheme: .darkened,
            foregroundLineColor: Color.white,
            font: .system(size: 48, weight: .bold)
        )
    }
}

struct WatchContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(examples) { example in
            WatchContentView(daysSince: example.daysSince)
                .previewDisplayName(example.description)
        }
    }
}
