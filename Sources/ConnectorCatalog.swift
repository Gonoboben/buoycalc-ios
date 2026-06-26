import Foundation

// MARK: - Пресет соединителя

struct ConnectorPreset: Identifiable, Hashable {
    var id: String

    var name: String
    var type: String

    var weightAirKg: Double
    var volumeM3: Double

    var breakingLoadKn: Double
    var projectedAreaM2: Double
    var dragCoefficient: Double

    var note: String

    var displayName: String {
        "\(type), MBL \(Int(breakingLoadKn)) кН"
    }
}

// MARK: - Базовая библиотека соединителей

struct ConnectorCatalog {

    static let presets: [ConnectorPreset] = [

        ConnectorPreset(
            id: "shackle_25",
            name: "Bow shackle 25 kN",
            type: "Скоба",
            weightAirKg: 0.6,
            volumeM3: 0.00008,
            breakingLoadKn: 25,
            projectedAreaM2: 0.003,
            dragCoefficient: 1.2,
            note: "Малая скоба. Может стать слабым звеном системы."
        ),

        ConnectorPreset(
            id: "shackle_55",
            name: "Bow shackle 55 kN",
            type: "Скоба усиленная",
            weightAirKg: 1.2,
            volumeM3: 0.00015,
            breakingLoadKn: 55,
            projectedAreaM2: 0.005,
            dragCoefficient: 1.2,
            note: "Более прочная скоба для средних нагрузок."
        ),

        ConnectorPreset(
            id: "swivel_60",
            name: "Swivel 60 kN",
            type: "Вертлюг",
            weightAirKg: 1.5,
            volumeM3: 0.00019,
            breakingLoadKn: 60,
            projectedAreaM2: 0.006,
            dragCoefficient: 1.2,
            note: "Вертлюг снижает перекручивание линии."
        ),

        ConnectorPreset(
            id: "quick_link_30",
            name: "Quick link 30 kN",
            type: "Карабин / звено",
            weightAirKg: 0.8,
            volumeM3: 0.00010,
            breakingLoadKn: 30,
            projectedAreaM2: 0.004,
            dragCoefficient: 1.2,
            note: "Удобный соединитель, но требует проверки паспортной нагрузки."
        ),

        ConnectorPreset(
            id: "acoustic_release_35",
            name: "Acoustic release 35 kN",
            type: "Акустический релиз",
            weightAirKg: 8.0,
            volumeM3: 0.003,
            breakingLoadKn: 35,
            projectedAreaM2: 0.03,
            dragCoefficient: 1.0,
            note: "Релиз может быть ограничивающим элементом по прочности и сопротивлению."
        )
    ]

    static func presetById(_ id: String) -> ConnectorPreset {
        return presets.first { $0.id == id } ?? presets[0]
    }
}
