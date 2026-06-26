import Foundation

// MARK: - Пресет якоря

struct AnchorPreset: Identifiable, Hashable {
    var id: String

    var name: String
    var type: String
    var material: String

    var weightAirKg: Double
    var volumeM3: Double
    var baseHoldingCoefficient: Double

    var note: String

    var displayName: String {
        "\(type) \(Int(weightAirKg)) кг"
    }
}

// MARK: - Базовая библиотека якорей

struct AnchorCatalog {

    static let presets: [AnchorPreset] = [

        AnchorPreset(
            id: "concrete_150",
            name: "Concrete block 150 kg",
            type: "Бетонный груз",
            material: "Concrete / Бетон",
            weightAirKg: 150,
            volumeM3: 0.063,
            baseHoldingCoefficient: 1.0,
            note: "Простой бетонный груз. Удержание примерно равно весу в воде."
        ),

        AnchorPreset(
            id: "concrete_300",
            name: "Concrete block 300 kg",
            type: "Бетонный груз",
            material: "Concrete / Бетон",
            weightAirKg: 300,
            volumeM3: 0.125,
            baseHoldingCoefficient: 1.0,
            note: "Более тяжёлый бетонный груз для предварительных расчётов."
        ),

        AnchorPreset(
            id: "steel_100",
            name: "Steel weight 100 kg",
            type: "Стальной груз",
            material: "Steel / Сталь",
            weightAirKg: 100,
            volumeM3: 0.013,
            baseHoldingCoefficient: 1.0,
            note: "Компактный стальной груз. Малый объём, большой вес в воде."
        ),

        AnchorPreset(
            id: "mushroom_75",
            name: "Mushroom anchor 75 kg",
            type: "Грибовидный якорь",
            material: "Steel / Сталь",
            weightAirKg: 75,
            volumeM3: 0.010,
            baseHoldingCoefficient: 2.5,
            note: "Грибовидный якорь может давать большее удержание на мягком грунте."
        ),

        AnchorPreset(
            id: "plate_80",
            name: "Plate anchor 80 kg",
            type: "Плитный якорь",
            material: "Steel / Сталь",
            weightAirKg: 80,
            volumeM3: 0.010,
            baseHoldingCoefficient: 4.0,
            note: "Плитный якорь может иметь высокий коэффициент удержания, но зависит от грунта и установки."
        )
    ]

    static func presetById(_ id: String) -> AnchorPreset {
        return presets.first { $0.id == id } ?? presets[0]
    }
}
