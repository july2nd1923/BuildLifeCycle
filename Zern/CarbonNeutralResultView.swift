//  CarbonNeutralResultView.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/4/25.

import SwiftUI

struct CarbonNeutralResultView: View {
    var materialRatios: [String: Double]
    var buildingArea: Double
    var energyUse: Double
    var emissionFactor: Double
    var lifeSpan: Int
    var offsetPeriod: Int
    var energySource: String

    @State private var selectedTab: Int = 0

    var body: some View {
        let result = CarbonZebCalculator.calculateAll(
            materialRatios: materialRatios,
            buildingArea: buildingArea,
            energyUse: energyUse,
            emissionFactor: emissionFactor,
            lifeSpan: lifeSpan,
            offsetPeriod: offsetPeriod,
            energySource: energySource
        )

        VStack(spacing: 20) {
            Text("📊 탄소중립 계산 결과")
                .font(.title2)
                .bold()

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    CategoryCard(title: "탄소", icon: "cube.box", index: 0, selectedTab: $selectedTab)
                    CategoryCard(title: "에너지", icon: "bolt.fill", index: 1, selectedTab: $selectedTab)
                }
                HStack(spacing: 12) {
                    CategoryCard(title: "건물", icon: "building.columns", index: 2, selectedTab: $selectedTab)
                    CategoryCard(title: "결과", icon: "checkmark.seal", index: 3, selectedTab: $selectedTab)
                }
            }

            Group {
                switch selectedTab {
                case 0:
                    CarbonInfoView(result: result)
                case 1:
                    EnergyInfoView(result: result, energySource: energySource)
                case 2:
                    BuildingInfoView(buildingArea: buildingArea, lifeSpan: lifeSpan, offsetPeriod: offsetPeriod)
                case 3:
                    ZebStatusView(result: result)
                default:
                    EmptyView()
                }
            }
            .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("결과 보기")
    }
}

// MARK: - 카드 뷰
struct CategoryCard: View {
    var title: String
    var icon: String
    var index: Int
    @Binding var selectedTab: Int

    var body: some View {
        Button(action: {
            selectedTab = index
        }) {
            VStack {
                Image(systemName: icon)
                    .font(.title)
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(.white)
            .frame(width: 100, height: 70)
            .background(selectedTab == index ? Color.blue : Color.gray)
            .cornerRadius(12)
        }
    }
}

// MARK: - 정보 뷰들
struct CarbonInfoView: View {
    var result: ZebResult
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("내재탄소량: \(String(format: "%.1f", result.embeddedCarbon)) kg CO₂")
            Text("운영탄소량: \(String(format: "%.1f", result.operatingCarbonPerYear)) kg CO₂/년")
            Text("총 탄소배출량: \(String(format: "%.1f", result.totalCarbon)) kg CO₂")
        }
    }
}

struct EnergyInfoView: View {
    var result: ZebResult
    var energySource: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("에너지원: \(energySource)")
            Text("연간 상쇄량: \(String(format: "%.1f", result.annualOffset)) kg CO₂/년")
            Text("상쇄 목표량: \(String(format: "%.1f", result.annualOffsetTarget)) kg CO₂/년")
            Text("필요 발전량: \(String(format: "%.1f", result.annualEnergyNeeded)) kWh/년")
            Text("발전 용량: \(String(format: "%.2f", result.requiredKW)) kW")
            Text("설치 면적: \(String(format: "%.2f", result.requiredArea)) ㎡")
        }
    }
}

struct BuildingInfoView: View {
    var buildingArea: Double
    var lifeSpan: Int
    var offsetPeriod: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("건물 면적: \(String(format: "%.1f", buildingArea)) ㎡")
            Text("생애주기: \(lifeSpan)년")
            Text("상쇄 기간: \(offsetPeriod)년")
        }
    }
}

struct ZebStatusView: View {
    var result: ZebResult
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let year = result.offsetYear {
                Text("상쇄 완료 연도: \(year)년")
            } else {
                Text("상쇄 완료 연도: 생애주기 내 달성 불가")
            }
            Text("ZEB 가능 여부: \(result.isZEB ? "가능" : "불가")")
                .bold()
        }
    }
}
