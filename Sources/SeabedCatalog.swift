import Foundation

// MARK: - Грунт дна

struct SeabedPreset: Identifiable, Hashable {
    var id: String
    var name: String

    // Множитель к базовому коэффициенту удержания якоря.
    // В версии 0.9 это учебное приближение.
    var holdingMultiplier: Double

    var note: String

    var displayName: String {
        name
    }
}

// MARK: - Базовая библиотека грунтов

struct SeabedCatalog {

    static let presets: [SeabedPreset] = [

        SeabedPreset(
            id: "unknown",
            name: "Неизвестный грунт",
            holdingMultiplier: 1.0,
            note: "Используйте только для предварительной оценки, если тип грунта неизвестен."
        ),

        SeabedPreset(
            id: "soft_mud",
            name: "Мягкий ил",
            holdingMultiplier: 1.3,
            note: "Некоторые якоря могут хорошо заглубляться, но грунт слабый и неоднородный."
        ),

        SeabedPreset(
            id: "sand",
            name: "Песок",
            holdingMultiplier: 1.1,
            note: "Обычно предсказуемый грунт, но удержание зависит от плотности песка."
        ),

        SeabedPreset(
            id: "clay",
            name: "Глина",
            holdingMultiplier: 1.2,
            note: "Может давать хорошее удержание при правильном заглублении якоря."
        ),

        SeabedPreset(
            id: "gravel",
            name: "Гравий / ракушечник",
            holdingMultiplier: 0.8,
            note: "Заглубление якоря может быть хуже, удержание менее предсказуемо."
        ),

        SeabedPreset(
            id: "rock",
            name: "Камень / скала",
            holdingMultiplier: 0.5,
            note: "Обычные якоря могут плохо держать без зацепа или специального крепления."
        )
    ]

    static func presetById(_ id: String) -> SeabedPreset {
        return presets.first { $0.id == id } ?? presets[0]
    }
}
