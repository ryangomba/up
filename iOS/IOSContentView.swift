import SwiftUI

struct IOSContentView: View {
    @ObservedObject var config: Config

    var body: some View {
        let dateBinding = Binding {
            return config.referenceDate
        } set: { value, _ in
            config.referenceDate = value
        }
        VStack {
            ProgressView(
                daysSince: config.daysSince(now: Date()),
                lineWidth: 12,
                backgroundLineScheme: .darkened,
                foregroundLineColor: Color.primary,
                font: .system(size: 96, weight: .bold)
            )
            DatePicker("Count from date", selection: dateBinding, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
        }
        .padding(.init(top: 44, leading: 44, bottom: 44, trailing: 44))
    }
}

struct IOSContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(examples) { example in
            IOSContentView(config: config)
                .previewDisplayName(example.description)
        }
    }
}
