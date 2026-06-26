import SwiftUI

struct MooringSideView: View {
    var depthM: Double
    var lineLengthM: Double
    var estimatedOffsetM: Double
    var maxOffsetM: Double
    var currentSpeedMS: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Схема сбоку")
                .font(.headline)

            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height

                let leftPadding: CGFloat = 48
                let rightPadding: CGFloat = 28
                let topPadding: CGFloat = 34
                let bottomPadding: CGFloat = 34

                let waterY = topPadding
                let seabedY = height - bottomPadding

                let anchorX = leftPadding
                let anchorY = seabedY

                let availableWidth = max(width - leftPadding - rightPadding, 1)
                let maxHorizontalM = max(maxOffsetM, estimatedOffsetM, depthM * 0.25, 1)

                let offsetRatio = estimatedOffsetM / maxHorizontalM
                let buoyX = anchorX + CGFloat(offsetRatio) * availableWidth
                let buoyY = waterY

                ZStack {
                    // Вода
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: waterY))
                        path.addLine(to: CGPoint(x: width, y: waterY))
                    }
                    .stroke(.blue, lineWidth: 2)

                    Text("Поверхность")
                        .font(.caption2)
                        .foregroundStyle(.blue)
                        .position(x: 62, y: waterY - 12)

                    // Дно
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: seabedY))
                        path.addLine(to: CGPoint(x: width, y: seabedY))
                    }
                    .stroke(.brown, lineWidth: 3)

                    Text("Дно")
                        .font(.caption2)
                        .foregroundStyle(.brown)
                        .position(x: 26, y: seabedY - 12)

                    // Вертикальная линия глубины
                    Path { path in
                        path.move(to: CGPoint(x: anchorX, y: waterY))
                        path.addLine(to: CGPoint(x: anchorX, y: seabedY))
                    }
                    .stroke(.gray.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [5, 5]))

                    Text("\(format(depthM)) м")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .position(x: anchorX + 28, y: (waterY + seabedY) / 2)

                    // Швартовная линия
                    Path { path in
                        path.move(to: CGPoint(x: anchorX, y: anchorY))
                        path.addLine(to: CGPoint(x: buoyX, y: buoyY))
                    }
                    .stroke(.primary, lineWidth: 3)

                    // Направление течения
                    Path { path in
                        let arrowY = waterY + 28
                        path.move(to: CGPoint(x: width - 100, y: arrowY))
                        path.addLine(to: CGPoint(x: width - 36, y: arrowY))
                        path.move(to: CGPoint(x: width - 48, y: arrowY - 8))
                        path.addLine(to: CGPoint(x: width - 36, y: arrowY))
                        path.addLine(to: CGPoint(x: width - 48, y: arrowY + 8))
                    }
                    .stroke(.cyan, lineWidth: 2)

                    Text("течение \(format(currentSpeedMS)) м/с")
                        .font(.caption2)
                        .foregroundStyle(.cyan)
                        .position(x: width - 92, y: waterY + 12)

                    // Якорь
                    Text("⚓")
                        .font(.title)
                        .position(x: anchorX, y: anchorY - 10)

                    // Буй
                    Circle()
                        .frame(width: 28, height: 28)
                        .position(x: buoyX, y: buoyY)

                    Text("буй")
                        .font(.caption2)
                        .position(x: buoyX, y: buoyY - 24)

                    // Снос
                    Path { path in
                        path.move(to: CGPoint(x: anchorX, y: waterY + 18))
                        path.addLine(to: CGPoint(x: buoyX, y: waterY + 18))
                    }
                    .stroke(.orange, style: StrokeStyle(lineWidth: 2, dash: [4, 4]))

                    Text("снос \(format(estimatedOffsetM)) м")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                        .position(x: (anchorX + buoyX) / 2, y: waterY + 34)
                }
            }
            .frame(height: 260)
            .background(Color.gray.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text("Схема показывает упрощённый вид сбоку. Масштаб адаптирован под экран, поэтому это не чертёж в строгом масштабе.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    func format(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
}

#Preview {
    MooringSideView(
        depthM: 50,
        lineLengthM: 55,
        estimatedOffsetM: 5.3,
        maxOffsetM: 22.9,
        currentSpeedMS: 0.5
    )
    .padding()
}
