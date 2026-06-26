import SwiftUI

struct VerdictCardView: View {
    var result: CalculationResult

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Вердикт системы")
                .font(.headline)

            Text(result.verdict.title)
                .font(.title3)
                .bold()

            Divider()

            resultRow(
                title: "Главный риск",
                value: result.verdict.mainRisk
            )

            resultRow(
                title: "Слабое звено",
                value: result.verdict.weakestElement
            )

            resultRow(
                title: "Рекомендация",
                value: result.verdict.recommendation
            )

            Divider()

            resultRow(
                title: "Запас плавучести",
                value: "\(format(result.buoyancyReserveKg)) кг"
            )

            resultRow(
                title: "Запас якоря",
                value: format(result.anchorSafetyRatio)
            )

            resultRow(
                title: "Запас по натяжению",
                value: format(result.tensionSafetyRatio)
            )

            resultRow(
                title: "Рабочая нагрузка системы",
                value: "\(format(result.systemWorkingLoadKn)) кН"
            )

            resultRow(
                title: "Расчётное натяжение",
                value: "\(format(result.estimatedLineTensionKn)) кН"
            )
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    func resultRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.body)
        }
    }

    var backgroundColor: Color {
        switch result.status {
        case .ok:
            return Color.green.opacity(0.12)
        case .warning:
            return Color.yellow.opacity(0.18)
        case .failed:
            return Color.red.opacity(0.12)
        }
    }

    func format(_ value: Double) -> String {
        if value > 100 {
            return String(format: "%.0f", value)
        }

        return String(format: "%.2f", value)
    }
}

#Preview {
    let verdict = SystemVerdict(
        title: "✅ Система предварительно подходит",
        mainRisk: "Критических рисков не выявлено.",
        weakestElement: "Соединительные элементы",
        recommendation: "Можно переходить к уточнению исходных данных."
    )

    let result = CalculationResult(
        buoyVolumeM3: 0.5,
        grossBuoyancyKg: 512.5,
        buoyProjectedAreaM2: 0.8,
        mooringLineProjectedAreaM2: 1.0,
        connectorProjectedAreaM2: 0.02,
        payloadProjectedAreaM2: 0.05,
        buoyCurrentForceN: 80,
        mooringLineCurrentForceN: 150,
        connectorCurrentForceN: 5,
        payloadCurrentForceN: 10,
        totalCurrentForceN: 245,
        totalCurrentForceKn: 0.245,
        waveOrbitalVelocityMS: 0.52,
        buoyWaveForceN: 110,
        totalHorizontalForceN: 355,
        totalHorizontalForceKn: 0.355,
        payloadWeightInWaterKg: 40,
        mooringLineWeightInWaterKg: 25,
        connectorWeightInWaterKg: 2,
        totalVerticalLoadKg: 147,
        buoyancyReserveKg: 365.5,
        mooringLineLengthM: 55,
        mooringLineMinimumBreakingLoadKn: 70,
        connectorMinimumBreakingLoadKn: 55,
        systemMinimumBreakingLoadKn: 55,
        systemWorkingLoadKn: 11,
        estimatedLineTensionKn: 1.5,
        tensionSafetyRatio: 7.33,
        anchorWeightInWaterKg: 170,
        anchorEffectiveHoldingCoefficient: 1.0,
        anchorHoldingCapacityKn: 1.67,
        requiredHoldingKn: 0.355,
        anchorSafetyRatio: 4.7,
        maxGeometricOffsetM: 22.9,
        estimatedCurrentOffsetM: 5.0,
        mooringAngleDeg: 24.6,
        forceAngleDeg: 5.6,
        status: .ok,
        messages: [],
        verdict: verdict
    )

    VerdictCardView(result: result)
        .padding()
}
