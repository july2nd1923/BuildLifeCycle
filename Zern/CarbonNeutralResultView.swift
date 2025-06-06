//
//  CarbonNeutralResultView.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/4/25.
//

import SwiftUI

struct CarbonNeutralResultView: View {
    // 계산에 필요한 모든 입력값
    var materialRatios: [String: Double]
    var buildingArea: Double
    var energyUse: Double
    var emissionFactor: Double
    var lifeSpan: Int
    var offsetPeriod: Int
    var energySource: String

    // 선택된 탭 상태
    @State private var selectedTab: Int = 0

    // 모든 에너지 소스 리스트
    let allSources = ["Solar", "Wind", "Geothermal", "Biomass", "Hydropower"]

    var body: some View {
        // 탄소중립 계산 실행
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
            Text("📊 Carbon Neutrality Result")
                .font(.title2)
                .bold()

            // 상단 탭 버튼 (카드 UI)
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    CategoryCard(title: "Carbon", icon: "cube.box", index: 0, selectedTab: $selectedTab)
                    CategoryCard(title: "Energy", icon: "bolt.fill", index: 1, selectedTab: $selectedTab)
                }
                HStack(spacing: 12) {
                    CategoryCard(title: "Building", icon: "building.columns", index: 2, selectedTab: $selectedTab)
                    CategoryCard(title: "Comparison", icon: "chart.bar", index: 3, selectedTab: $selectedTab)
                }
            }

            // 선택된 탭에 따라 결과 화면 전환
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
        .navigationTitle("View Result")
    }
}

// 탭 버튼을 구성하는 카드형 UI
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

// 탭 0: 탄소량 정보 표시
struct CarbonInfoView: View {
    var result: ZebResult
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Embedded Carbon: \(String(format: "%.1f", result.embeddedCarbon)) kg CO₂")
            Text("Operating Carbon: \(String(format: "%.1f", result.operatingCarbonPerYear)) kg CO₂/year")
            Text("Total Carbon Emission: \(String(format: "%.1f", result.totalCarbon)) kg CO₂")
        }
    }
}

// 탭 1: 에너지 정보 표시
struct EnergyInfoView: View {
    var result: ZebResult
    var energySource: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Energy Source: \(energySource)")
            Text("Annual Offset: \(String(format: "%.1f", result.annualOffset)) kg CO₂/year")
            Text("Offset Goal: \(String(format: "%.1f", result.annualOffsetTarget)) kg CO₂/year")
            Text("Required Generation: \(String(format: "%.1f", result.annualEnergyNeeded)) kWh/year")
            Text("Required Capacity: \(String(format: "%.2f", result.requiredKW)) kW")
            Text("Installation Area: \(String(format: "%.2f", result.requiredArea)) ㎡")
        }
    }
}

// 탭 2: 건물 정보 표시
struct BuildingInfoView: View {
    var buildingArea: Double
    var lifeSpan: Int
    var offsetPeriod: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Building Area: \(String(format: "%.1f", buildingArea)) ㎡")
            Text("Lifespan: \(lifeSpan) years")
            Text("Offset Period: \(offsetPeriod) years")
        }
    }
}

// 탭 3: 다른 에너지원들과의 비교
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
            Text("⚖️ Comparison with Other Energy Sources")
                .font(.headline)

            ForEach(allSources.filter { $0 != currentSource }, id: \.self) { source in
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
                        Text(result.isZEB ? "ZEB Achievable" : "ZEB Not Achievable")
                            .foregroundColor(result.isZEB ? .green : .red)
                            .bold()
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Emission: \(String(format: "%.0f", result.totalCarbon)) kg CO₂")
                        Text("Required Generation: \(String(format: "%.0f", result.annualEnergyNeeded)) kWh/year")
                        Text("Required Area: \(String(format: "%.1f", result.requiredArea)) ㎡")
                        if let year = result.offsetYear {
                            Text("Offset Completion Year: \(year)")
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
