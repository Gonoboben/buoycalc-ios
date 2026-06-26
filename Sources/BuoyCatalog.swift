import Foundation

// MARK: - Пресет буя

struct BuoyPreset: Identifiable, Hashable {
    var id: String

    var name: String
    var type: String
    var shape: BuoyShape

    var diameterM: Double
    var heightM: Double
    var customVolumeM3: Double

    var weightKg: Double
    var dragCoefficient: Double

    var note: String

    var displayName: String {
        "\(type), \(format(diameterM)) м"
    }

    private func format(_ value: Double) -> String {
        if value >= 1 {
            return String(format: "%.1f", value)
        }

        return String(format: "%.2f", value)
    }
}

// MARK: - Базовая библиотека буёв

struct BuoyCatalog {

    static let presets: [BuoyPreset] = [

        BuoyPreset(
            id: "cylinder_08x10_80",
            name: "Cylindrical buoy 0.8 x 1.0 m",
            type: "Цилиндрический буй",
            shape: .cylinder,
            diameterM: 0.8,
            heightM: 1.0,
            customVolumeM3: 0.50,
            weightKg: 80,
            dragCoefficient: 0.8,
            note: "Учебный цилиндрический буй. Хорошо подходит для первого тестового расчёта."
        ),

        BuoyPreset(
            id: "cylinder_06x08_45",
            name: "Cylindrical buoy 0.6 x 0.8 m",
            type: "Малый цилиндрический буй",
            shape: .cylinder,
            diameterM: 0.6,
            heightM: 0.8,
            customVolumeM3: 0.23,
            weightKg: 45,
            dragCoefficient: 0.8,
            note: "Меньший учебный буй для лёгкой постановки или проверки чувствительности расчёта."
        ),

        BuoyPreset(
            id: "sphere_08_60",
            name: "Spherical buoy 0.8 m",
            type: "Сферический буй",
            shape: .sphere,
            diameterM: 0.8,
            heightM: 0.8,
            customVolumeM3: 0.27,
            weightKg: 60,
            dragCoefficient: 0.5,
            note: "Сферический буй с меньшим коэффициентом сопротивления в упрощённой модели."
        ),

        BuoyPreset(
            id: "sphere_10_90",
            name: "Spherical buoy 1.0 m",
            type: "Крупный сферический буй",
            shape: .sphere,
            diameterM: 1.0,
            heightM: 1.0,
            customVolumeM3: 0.52,
            weightKg: 90,
            dragCoefficient: 0.5,
            note: "Более крупный сферический буй с большим запасом плавучести."
        ),

        BuoyPreset(
            id: "passport_050_70",
            name: "Passport buoy volume 0.50 m3",
            type: "Паспортный объём",
            shape: .custom,
            diameterM: 0.8,
            heightM: 1.0,
            customVolumeM3: 0.50,
            weightKg: 70,
            dragCoefficient: 0.8,
            note: "Пример буя, у которого объём задан по паспорту, а размеры используются для сопротивления."
        )
    ]

    static func presetById(_ id: String) -> BuoyPreset {
        return presets.first { $0.id == id } ?? presets[0]
    }
}
