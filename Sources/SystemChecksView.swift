import SwiftUI

struct SystemChecksView: View {
    var result: CalculationResult
    var depthM: Double
    var lineLengthM: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Проверки системы")
                .font(.headline)

            Text("Краткая проверка ключевых ограничений расчёта.")
                .font(.caption)
                .foregroundColor(.secondary)

            checkRow(
                title: "Плавучесть",
                isOk: result.buoyancyReserveKg > 0,
                value: "Запас: \(format(result.buoyancyReserveKg)) кг"
            )

            checkRow(
                title: "Длина линии",
                isOk: lineLengthM >= depthM,
                value: "Линия: \(format(lineLengthM)) м / глубина: \(format(depthM)) м"
            )

            checkRow(
                title: "Натяжение",
                isOk: result.estimatedLineTensionKn <= result.systemWorkingLoadKn,
                value: "T: \(format(result.estimatedLineTensionKn)) кН / WLL: \(format(result.systemWorkingLoadKn)) кН"
            )

            checkRow(
                title: "Якорь",
                isOk: result.anchorSafetyRatio >= 1,
                value: "Запас: \(format(result.anchorSafetyRatio))"
            )

            checkRow(
                title: "Снос",
                isOk: result.estimatedCurrentOffsetM <= result.maxGeometricOffsetM,
                value: "Снос: \(format(result.estimatedCurrentOffsetM)) м"
            )

            checkRow(
                title: "Слабое звено",
                isOk: result.systemMinimumBreakingLoadKn > 0,
                value: result.verdict.weakestElement
            )
        }
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(16)
    }

    func checkRow(title: String, isOk: Bool, value: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(isOk ? "✅" : "⚠️")
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(value)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.65))
        .cornerRadius(12)
    }

    func format(_ value: Double) -> String {
        if value.isNaN || value.isInfinite {
            return "—"
        }

        if abs(value) >= 100 {
            return String(format: "%.0f", value)
        }

        return String(format: "%.2f", value)
    }
}
