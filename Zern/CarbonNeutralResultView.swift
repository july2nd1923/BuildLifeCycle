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
    let allSources = ["태양광", "풍력", "지열", "바이오", "수력"]

    var body: some View {
        let selectedResult = CarbonZebCalculator.calculateAll(
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
                    CategoryCard(title: "비교", icon: "chart.bar", index: 3, selectedTab: $selectedTab)
                }
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Group {
                        switch selectedTab {
                        case 0:
                            CarbonInfoView(result: selectedResult)
                        case 1:
                            EnergyInfoView(result: selectedResult, energySource: energySource)
                        case 2:
                            BuildingInfoView(buildingArea: buildingArea, lifeSpan: lifeSpan, offsetPeriod: offsetPeriod)
                        case 3:
                            ComparisonTabView(
                                allSources: allSources,
                                currentSource: energySource,
                                materialRatios: materialRatios,
                                buildingArea: buildingArea,
                                energyUse: energyUse,
                                emissionFactor: emissionFactor,
                                lifeSpan: lifeSpan,
                                offsetPeriod: offsetPeriod
                            )
                        default:
                            EmptyView()
                        }
                    }
                }
                .padding()
            }
        }
        .padding()
        .navigationTitle("결과 보기")
    }
}

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

struct ComparisonTabView: View {
    let allSources: [String]
    let currentSource: String
    let materialRatios: [String: Double]
    let buildingArea: Double
    let energyUse: Double
    let emissionFactor: Double
    let lifeSpan: Int
    let offsetPeriod: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚖️ 다른 에너지원과의 비교")
                .font(.headline)

            ForEach(allSources.filter { $0 != currentSource }, id: \ .self) { source in
                let result = CarbonZebCalculator.calculateAll(
                    materialRatios: materialRatios,
                    buildingArea: buildingArea,
                    energyUse: energyUse,
                    emissionFactor: emissionFactor,
                    lifeSpan: lifeSpan,
                    offsetPeriod: offsetPeriod,
                    energySource: source
                )

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label(source, systemImage: "leaf.fill")
                            .font(.headline)
                            .foregroundColor(.green)
                        Spacer()
                        Text(result.isZEB ? "ZEB 가능" : "ZEB 불가")
                            .foregroundColor(result.isZEB ? .green : .red)
                            .bold()
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("총 탄소배출량: \(String(format: "%.0f", result.totalCarbon)) kg CO₂")
                        Text("발전량 필요: \(String(format: "%.0f", result.annualEnergyNeeded)) kWh/년")
                        Text("설치 면적: \(String(format: "%.1f", result.requiredArea)) ㎡")
                        if let year = result.offsetYear {
                            Text("상쇄 완료 연도: \(year)년")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
}
