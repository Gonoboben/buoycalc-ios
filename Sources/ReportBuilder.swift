import Foundation

// MARK: - Генератор инженерного отчёта

struct ReportBuilder {

    static func makeReport(
        project: BuoyProject,
        result: CalculationResult,
        mooringLine: MooringLine,
        connectors: ConnectorSet,
        environment: Environment,
        buoy: Buoy,
        payload: Payload,
        anchor: Anchor
    ) -> String {

        let dateText = formattedDate(Date())

        return """
        # BuoyCalc — предварительный инженерный отчёт

        Дата формирования: \(dateText)
        Название проекта: \(project.name)

        ---

        ## 1. Итоговый вердикт

        \(result.verdict.title)

        Главный риск:
        \(result.verdict.mainRisk)

        Слабое звено:
        \(result.verdict.weakestElement)

        Рекомендация:
        \(result.verdict.recommendation)

        ---

        ## 2. Условия постановки

        | Параметр | Значение |
        |---|---:|
        | Глубина | \(format(environment.depthM)) м |
        | Плотность воды | \(format(environment.waterDensityKgM3)) кг/м³ |
        | Скорость течения | \(format(environment.currentSpeedMS)) м/с |
        | Высота волны | \(format(environment.waveHeightM)) м |
        | Период волны | \(format(environment.wavePeriodS)) с |
        | Тип грунта | \(environment.seabed.name) |
        | Множитель грунта | \(format(environment.seabed.holdingMultiplier)) |

        ---

        ## 3. Буй

        | Параметр | Значение |
        |---|---:|
        | Форма | \(buoy.shape.rawValue) |
        | Диаметр / ширина | \(format(buoy.diameterM)) м |
        | Высота | \(format(buoy.heightM)) м |
        | Объём | \(format(result.buoyVolumeM3)) м³ |
        | Масса | \(format(buoy.weightKg)) кг |
        | Полная плавучесть | \(format(result.grossBuoyancyKg)) кг |
        | Площадь сопротивления | \(format(result.buoyProjectedAreaM2)) м² |
        | Сила течения на буй | \(format(result.buoyCurrentForceN)) Н |
        | Волновая сила на буй | \(format(result.buoyWaveForceN)) Н |

        ---

        ## 4. Швартовная линия

        \(mooringLineTable(mooringLine))

        Суммарная длина линии: \(format(result.mooringLineLengthM)) м  
        Вес линии в воде: \(format(result.mooringLineWeightInWaterKg)) кг  
        Площадь сопротивления линии: \(format(result.mooringLineProjectedAreaM2)) м²  
        Сила течения на линию: \(format(result.mooringLineCurrentForceN)) Н  
        Минимальная разрывная нагрузка линии: \(format(result.mooringLineMinimumBreakingLoadKn)) кН

        ---

        ## 5. Соединительные элементы

        \(connectorsTable(connectors))

        Вес соединителей в воде: \(format(result.connectorWeightInWaterKg)) кг  
        Площадь сопротивления соединителей: \(format(result.connectorProjectedAreaM2)) м²  
        Сила течения на соединители: \(format(result.connectorCurrentForceN)) Н  
        Минимальная разрывная нагрузка соединителей: \(format(result.connectorMinimumBreakingLoadKn)) кН

        ---

        ## 6. Прибор / полезная нагрузка

        | Параметр | Значение |
        |---|---:|
        | Название | \(payload.name) |
        | Масса в воздухе | \(format(payload.weightAirKg)) кг |
        | Объём | \(format(payload.volumeM3)) м³ |
        | Вес в воде | \(format(result.payloadWeightInWaterKg)) кг |
        | Площадь сопротивления | \(format(result.payloadProjectedAreaM2)) м² |
        | Сила течения на прибор | \(format(result.payloadCurrentForceN)) Н |

        ---

        ## 7. Якорь

        | Параметр | Значение |
        |---|---:|
        | Тип | \(anchor.type) |
        | Материал | \(anchor.material) |
        | Масса в воздухе | \(format(anchor.weightAirKg)) кг |
        | Объём | \(format(anchor.volumeM3)) м³ |
        | Масса в воде | \(format(result.anchorWeightInWaterKg)) кг |
        | Эффективный коэффициент удержания | \(format(result.anchorEffectiveHoldingCoefficient)) |
        | Удерживающая способность | \(format(result.anchorHoldingCapacityKn)) кН |
        | Требуемое удержание | \(format(result.requiredHoldingKn)) кН |
        | Запас удержания | \(format(result.anchorSafetyRatio)) |

        ---

        ## 8. Расчётные итоги

        | Параметр | Значение |
        |---|---:|
        | Суммарная сила течения | \(format(result.totalCurrentForceN)) Н |
        | Суммарная горизонтальная сила | \(format(result.totalHorizontalForceN)) Н |
        | Общая вертикальная нагрузка | \(format(result.totalVerticalLoadKg)) кг |
        | Запас плавучести | \(format(result.buoyancyReserveKg)) кг |
        | Минимальная разрывная нагрузка системы | \(format(result.systemMinimumBreakingLoadKn)) кН |
        | Рабочая нагрузка системы | \(format(result.systemWorkingLoadKn)) кН |
        | Расчётное натяжение системы | \(format(result.estimatedLineTensionKn)) кН |
        | Запас по натяжению | \(format(result.tensionSafetyRatio)) |
        | Максимальный геометрический снос | \(format(result.maxGeometricOffsetM)) м |
        | Расчётный снос | \(format(result.estimatedCurrentOffsetM)) м |
        | Геометрический угол линии | \(format(result.mooringAngleDeg))° |
        | Угол от соотношения сил | \(format(result.forceAngleDeg))° |

        ---

        ## 9. Комментарии расчёта

        \(messagesText(result.messages))

        ---

        ## 10. Использованные упрощённые зависимости

        Сила сопротивления потоку:

        F = 0.5 × ρ × Cd × A × v²

        Приближённая орбитальная скорость волны у поверхности:

        u ≈ πH / T

        Расчётное натяжение системы:

        T = √(H² + V²)

        ---

        ## 11. Ограничения

        Этот отчёт является предварительным расчётом.

        Модель не заменяет:

        - расчёт цепной линии;
        - динамический расчёт волнения;
        - проверку усталости;
        - проверку по паспортам производителей;
        - инженерную методику для конкретного района постановки;
        - проверку грунта и фактического удержания якоря.

        Для реального проектирования необходимо использовать паспортные характеристики элементов, данные производителей и проверочную инженерную методику.
        """
    }

    private static func mooringLineTable(_ line: MooringLine) -> String {
        if line.segments.isEmpty {
            return "Участки швартовной линии не заданы."
        }

        var text = """
        | Участок | Материал | Диаметр | Длина | Вес в воде | MBL |
        |---:|---|---:|---:|---:|---:|
        """

        for (index, segment) in line.segments.enumerated() {
            text += "\n| \(index + 1) | \(segment.material) | \(format(segment.diameterMm)) мм | \(format(segment.lengthM)) м | \(format(segment.weightInWaterKg())) кг | \(format(segment.breakingLoadKn)) кН |"
        }

        return text
    }

    private static func connectorsTable(_ connectors: ConnectorSet) -> String {
        if connectors.elements.isEmpty {
            return "Соединительные элементы не заданы."
        }

        var text = """
        | Элемент | Тип | Кол-во | Вес в воде | Площадь | MBL |
        |---:|---|---:|---:|---:|---:|
        """

        for (index, item) in connectors.elements.enumerated() {
            text += "\n| \(index + 1) | \(item.type) | \(item.count) | \(format(item.weightAirKg)) кг/шт. в воздухе | \(format(item.projectedAreaM2)) м²/шт. | \(format(item.breakingLoadKn)) кН |"
        }

        return text
    }

    private static func messagesText(_ messages: [String]) -> String {
        if messages.isEmpty {
            return "Комментариев нет."
        }

        return messages.map { "- \($0)" }.joined(separator: "\n")
    }

    private static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: date)
    }

    private static func format(_ value: Double) -> String {
        if value.isNaN || value.isInfinite {
            return "—"
        }

        if abs(value) >= 100 {
            return String(format: "%.0f", value)
        }

        return String(format: "%.2f", value)
    }
}
