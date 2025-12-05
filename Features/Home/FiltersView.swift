import SwiftUI

struct FiltersView: View {
    @Binding var selectedTime: TimeWindow?
    @Binding var selectedEnergy: EnergyLevel?
    @Binding var selectedContext: SocialContext?

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingLarge) {
            // Time selection
            VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                Text("How much time?")
                    .font(Theme.headerFont())
                HStack(spacing: Theme.paddingSmall) {
                    ForEach(TimeWindow.allCases) { time in
                        Button(time.rawValue) {
                            selectedTime = time
                        }
                        .buttonStyle(MenuChipStyle(isSelected: selectedTime == time))
                    }
                }
            }

            // Energy selection
            VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                Text("What's your energy?")
                    .font(Theme.headerFont())
                HStack(spacing: Theme.paddingSmall) {
                    ForEach(EnergyLevel.allCases) { energy in
                        Button(energy.displayName) {
                            selectedEnergy = energy
                        }
                        .buttonStyle(MenuChipStyle(isSelected: selectedEnergy == energy))
                    }
                }
            }

            // Context selection
            VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                Text("Solo or with someone?")
                    .font(Theme.headerFont())
                HStack(spacing: Theme.paddingSmall) {
                    ForEach(SocialContext.allCases) { context in
                        Button(context.displayName) {
                            selectedContext = context
                        }
                        .buttonStyle(MenuChipStyle(isSelected: selectedContext == context))
                    }
                }
            }
        }
        .padding(Theme.padding)
    }
}

enum TimeWindow: String, CaseIterable, Identifiable {
    case short = "5-10 min"
    case medium = "15-30 min"
    case long = "30+ min"

    var id: String { rawValue }
    var minutes: ClosedRange<Int> {
        switch self {
        case .short: return 5...10
        case .medium: return 15...30
        case .long: return 30...120
        }
    }
}

enum EnergyLevel: String, CaseIterable, Identifiable {
    case low, okay, upForSomething

    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .low: return "Low"
        case .okay: return "Okay"
        case .upForSomething: return "Up for something"
        }
    }
}

enum SocialContext: String, CaseIterable, Identifiable {
    case solo, withSomeone

    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .solo: return "Solo"
        case .withSomeone: return "With someone"
        }
    }
}
