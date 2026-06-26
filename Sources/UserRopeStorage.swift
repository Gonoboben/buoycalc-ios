import Foundation

// MARK: - Пользовательский участок швартовной линии

struct UserRopeDraft: Identifiable, Codable, Hashable {
    var id: String

    var name: String
    var material: String
    var diameterMm: Double

    var breakingLoadKn: Double
    var weightWaterKgM: Double
    var dragCoefficient: Double

    var note: String
    var dataSource: ElementDataSource? = nil

    var displayName: String {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "\(material) \(Int(diameterMm)) мм"
        }

        return name
    }

    var asPreset: RopePreset {
        RopePreset(
            id: "user:\(id)",
            name: name,
            material: material,
            diameterMm: diameterMm,
            breakingLoadKn: breakingLoadKn,
            weightWaterKgM: weightWaterKgM,
            dragCoefficient: dragCoefficient,
            note: note
        )
    }
}

// MARK: - Хранилище пользовательских участков швартовной линии

enum UserRopeStorage {
    private static let key = "BuoyCalc.userRopes.v1"

    static func loadAll() -> [UserRopeDraft] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }

        do {
            return try JSONDecoder().decode([UserRopeDraft].self, from: data)
        } catch {
            print("Ошибка загрузки пользовательских участков линии: \(error.localizedDescription)")
            return []
        }
    }

    static func saveAll(_ ropes: [UserRopeDraft]) {
        do {
            let data = try JSONEncoder().encode(ropes)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Ошибка сохранения пользовательских участков линии: \(error.localizedDescription)")
        }
    }

    static func upsert(_ rope: UserRopeDraft) {
        var ropes = loadAll()

        if let index = ropes.firstIndex(where: { $0.id == rope.id }) {
            ropes[index] = rope
        } else {
            ropes.append(rope)
        }

        saveAll(ropes)
    }

    static func delete(id: String) {
        let ropes = loadAll().filter { $0.id != id }
        saveAll(ropes)
    }
}
