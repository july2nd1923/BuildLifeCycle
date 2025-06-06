//
//  CarbonZebCalculator.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/5/25.
//

import Foundation

struct CarbonZebCalculator {
    static func calculateAll(
        materialRatios: [String: Double],  // 재료별 비율 (%)
        buildingArea: Double,              // 건물 연면적 (㎡)
        energyUse: Double,                 // 연간 에너지 사용량 (kWh)
        emissionFactor: Double,           // 전력 탄소계수 (kgCO₂/kWh)
        lifeSpan: Int,                    // 건물 생애주기 (년)
        offsetPeriod: Int,                // 상쇄 목표 기간 (년)
        energySource: String,             // 선택한 에너지원
        reductionFactor: Double = 0.45,   // 에너지 상쇄 효율
        installAreaPerKW: Double = 3.5    // 1kW당 설치 면적 (㎡)
    ) -> ZebResult {

        // [1] 내재 탄소량 계산
        let embeddedCarbon = materialRatios.reduce(0.0) { partialResult, entry in
            let material = entry.key
            let ratio = entry.value / 100.0
            let factor = CarbonDatabase.unitCarbonPerArea[material] ?? 0.0
            return partialResult + ratio * factor * buildingArea
        }

        // [2] 운영 탄소량 계산 (연간)
        let operatingCarbonPerYear = energyUse * emissionFactor

        // [3] 총 탄소배출량 계산
        let totalCarbon = embeddedCarbon + Double(lifeSpan) * operatingCarbonPerYear

        // [4] 연간 목표 상쇄량 계산
        let generationPerKW = generationFactor(for: energySource)
        let annualOffsetTarget = totalCarbon / Double(offsetPeriod)
        let annualEnergyNeeded = annualOffsetTarget / reductionFactor
        let requiredKW = annualEnergyNeeded / generationPerKW
        let requiredArea = requiredKW * installAreaPerKW

        // [5] 연도별 누적 상쇄량 계산
        var cumulativeOffset: Double = 0.0
        var offsetData: [(year: Int, cumulative: Double)] = []
        let currentYear = Calendar.current.component(.year, from: Date())
        let annualOffset = generationPerKW * requiredKW * reductionFactor
        var offsetYear: Int? = nil

        for i in 0..<lifeSpan {
            cumulativeOffset += annualOffset
            let year = currentYear + i
            offsetData.append((year: year, cumulative: cumulativeOffset))
            if offsetYear == nil && cumulativeOffset >= totalCarbon {
                offsetYear = year
            }
        }

        // [6] ZEB 달성 여부 판단
        let isZEB = (offsetYear != nil && offsetYear! <= currentYear + lifeSpan)

        return ZebResult(
            embeddedCarbon: embeddedCarbon,
            operatingCarbonPerYear: operatingCarbonPerYear,
            totalCarbon: totalCarbon,
            annualOffsetTarget: annualOffsetTarget,
            annualEnergyNeeded: annualEnergyNeeded,
            requiredKW: requiredKW,
            requiredArea: requiredArea,
            offsetYear: offsetYear,
            isZEB: isZEB,
            offsetData: offsetData,
            annualOffset: annualOffset
        )
    }

    // 에너지원별 연간 발전량 상수값 반환
    private static func generationFactor(for source: String) -> Double {
        switch source {
        case "Solar": return 1460     // 4시간/일 × 365일
        case "Wind":  return 2190     // 6시간/일 × 365일
        case "Geothermal": return 2630
        case "Biomass": return 2920
        case "Hydropower": return 4380
        default: return 1460         // 기본은 태양광
        }
    }
}

// 탄소중립 계산 결과 구조체
struct ZebResult {
    let embeddedCarbon: Double              // 내재탄소량 (kg CO₂)
    let operatingCarbonPerYear: Double      // 연간 운영탄소량 (kg CO₂)
    let totalCarbon: Double                 // 총 탄소배출량 (kg CO₂)
    let annualOffsetTarget: Double          // 연간 상쇄 목표량 (kg CO₂)
    let annualEnergyNeeded: Double          // 연간 발전 필요량 (kWh)
    let requiredKW: Double                  // 필요한 발전 용량 (kW)
    let requiredArea: Double                // 설치 면적 (㎡)
    let offsetYear: Int?                    // 상쇄 완료 연도
    let isZEB: Bool                         // ZEB 달성 여부
    let offsetData: [(year: Int, cumulative: Double)] // 연도별 누적 상쇄량
    let annualOffset: Double                // 연간 상쇄량 (kg CO₂)
}
