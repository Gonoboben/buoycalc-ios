import Foundation

// MARK: - Пользовательский буй

struct UserBuoyDraft: Identifiable, Codable, Hashable {
    var id: String

    var name: String
    var type: String
    var shapeRawValue: String

    var diameterM: Double
    var heightM: Double
    var customVolumeM3: Double

    var weightKg: Double
    var dragCoefficient: Double

    var note: String
    var dataSource: ElementDataSource? = nil

    var shape: BuoyShape {
        BuoyShape(rawValue: shapeRawValue) ?? .custom
    }

    var displayName: String {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Пользовательский буй"
        }

        return name
    }

    var asPreset: BuoyPreset {
        BuoyPreset(
            id: "user:\(id)",
            name: name,
            type: type,
            shape: shape,
            diameterM: diameterM,
            heightM: heightM,
            customVolumeM3: customVolumeM3,
            weightKg: weightKg,
            dragCoefficient: dragCoefficient,
            note: note
        )
    }
}

// MARK: - Хранилище пользовательских буёв

enum UserBuoyStorage {
    private static let key = "BuoyCalc.userBuoys.v1"

    static func loadAll() -> [UserBuoyDraft] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }

        do {
            return try JSONDecoder().decode([UserBuoyDraft].self, from: data)
        } catch {
            print("Ошибка загрузки пользовательских буёв: \(error.localizedDescription)")
            return []
        }
    }

    static func saveAll(_ buoys: [UserBuoyDraft]) {
        do {
            let data = try JSONEncoder().encode(buoys)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Ошибка сохранения пользовательских буёв: \(error.localizedDescription)")
        }
    }

    static func upsert(_ buoy: UserBuoyDraft) {
        var buoys = loadAll()

        if let index = buoys.firstIndex(where: { $0.id == buoy.id }) {
            buoys[index] = buoy
        } else {
            buoys.append(buoy)
        }

        saveAll(buoys)
    }

    static func delete(id: String) {
        let buoys = loadAll().filter { $0.id != id }
        saveAll(buoys)
    }
}
