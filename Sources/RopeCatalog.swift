import Foundation

// MARK: - Пресет участка швартовной линии

struct RopePreset: Identifiable, Hashable {
    var id: String

    var name: String
    var material: String
    var diameterMm: Double

    var breakingLoadKn: Double
    var weightWaterKgM: Double
    var dragCoefficient: Double

    var note: String

    var displayName: String {
        "\(material) \(Int(diameterMm)) мм"
    }
}

// MARK: - Базовая библиотека участков швартовной линии

struct RopeCatalog {

    static let presets: [RopePreset] = [

        RopePreset(
            id: "nylon_16",
            name: "Nylon rope 16 mm",
            material: "Nylon / Полиамид",
            diameterMm: 16,
            breakingLoadKn: 45,
            weightWaterKgM: 0.08,
            dragCoefficient: 1.2,
            note: "Эластичный канат. Хорошо гасит рывки, но растягивается."
        ),

        RopePreset(
            id: "polyester_20",
            name: "Polyester rope 20 mm",
            material: "Polyester / Полиэстер",
            diameterMm: 20,
            breakingLoadKn: 70,
            weightWaterKgM: 0.15,
            dragCoefficient: 1.2,
            note: "Популярный вариант для морской среды. Меньше растягивается, чем nylon."
        ),

        RopePreset(
            id: "polypropylene_20",
            name: "Polypropylene rope 20 mm",
            material: "Polypropylene / Полипропилен",
            diameterMm: 20,
            breakingLoadKn: 45,
            weightWaterKgM: -0.03,
            dragCoefficient: 1.2,
            note: "Положительная плавучесть. Может всплывать."
        ),

        RopePreset(
            id: "hmpe_12",
            name: "HMPE rope 12 mm",
            material: "HMPE / Dyneema",
            diameterMm: 12,
            breakingLoadKn: 90,
            weightWaterKgM: -0.01,
            dragCoefficient: 1.1,
            note: "Высокая прочность при малом диаметре. Дороже обычных канатов."
        ),

        RopePreset(
            id: "steel_wire_8",
            name: "Steel wire rope 8 mm",
            material: "Steel wire rope / Стальной трос",
            diameterMm: 8,
            breakingLoadKn: 40,
            weightWaterKgM: 0.20,
            dragCoefficient: 1.1,
            note: "Отрицательная плавучесть, высокая жёсткость."
        ),

        RopePreset(
            id: "chain_10",
            name: "Chain 10 mm",
            material: "Chain / Цепь",
            diameterMm: 10,
            breakingLoadKn: 80,
            weightWaterKgM: 1.80,
            dragCoefficient: 1.4,
            note: "Большой вес в воде. Полезна как нижний участок швартовки."
        )
    ]

    static func presetById(_ id: String) -> RopePreset {
        return presets.first { $0.id == id } ?? presets[0]
    }
}
