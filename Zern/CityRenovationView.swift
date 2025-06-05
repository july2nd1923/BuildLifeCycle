//
//  CityRenovationView.swift
//  Zern
//
//  Created by Juliana Lee on 6/6/25.

import SwiftUI

struct BuildingLifecycle: Identifiable {
    let id = UUID()
    let name: String
    let builtYear: Int
    let initialLife: Int
    let repairCycle: Int
    let extensionPerRepair: Int
    let isZEB: Bool
}

struct CityRenovationView: View {
    @State private var buildings: [BuildingLifecycle] = []

    @State private var name = ""
    @State private var builtYear = Calendar.current.component(.year, from: Date())
    @State private var initialLife = ""
    @State private var repairCycle = ""
    @State private var extensionPerRepair = ""
    @State private var isZEB = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🏙 도시 리노베이션 시뮬레이터")
                    .font(.title2)
                    .bold()

                // 입력 폼
                GroupBox(label: Text("건물 정보 추가하기").bold()) {
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("건물 이름", text: $name)
                        TextField("준공 연도", value: $builtYear, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                        TextField("초기 생애주기 (년)", text: $initialLife)
                            .keyboardType(.numberPad)
                        TextField("보수 주기 (년)", text: $repairCycle)
                            .keyboardType(.numberPad)
                        TextField("보수 시 연장 (년)", text: $extensionPerRepair)
                            .keyboardType(.numberPad)
                        Toggle("ZEB 가능 여부", isOn: $isZEB)

                        Button("➕ 건물 추가") {
                            if let life = Int(initialLife),
                               let cycle = Int(repairCycle),
                               let extend = Int(extensionPerRepair) {
                                let newBuilding = BuildingLifecycle(
                                    name: name,
                                    builtYear: builtYear,
                                    initialLife: life,
                                    repairCycle: cycle,
                                    extensionPerRepair: extend,
                                    isZEB: isZEB
                                )
                                buildings.append(newBuilding)
                                name = ""
                                builtYear = Calendar.current.component(.year, from: Date())
                                initialLife = ""
                                repairCycle = ""
                                extensionPerRepair = ""
                                isZEB = false
                            }
                        }
                        .padding(.top, 4)
                    }
                }

                // 타임라인 뷰
                ForEach(buildings) { building in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("🏢 \(building.name)")
                            .font(.headline)

                        GeometryReader { geometry in
                            let totalYears = projectedLife(for: building)
                            let barWidth = geometry.size.width / CGFloat(totalYears)

                            HStack(spacing: 0) {
                                ForEach(0..<totalYears, id: \ .self) { yearIndex in
                                    let isRepairYear = building.repairCycle > 0 && yearIndex > 0 && yearIndex % building.repairCycle == 0

                                    Rectangle()
                                        .fill(isRepairYear ? Color.orange : (building.isZEB ? Color.green.opacity(0.8) : Color.gray.opacity(0.5)))
                                        .frame(width: barWidth, height: 18)
                                }
                            }
                        }
                        .frame(height: 20)

                        HStack {
                            Text("준공: \(building.builtYear)년")
                            Text("예상 생애주기: \(projectedLife(for: building))년")
                            Text(building.isZEB ? "ZEB 가능" : "ZEB 불가")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("도시 리노베이션")
    }

    func projectedLife(for building: BuildingLifecycle) -> Int {
        guard building.repairCycle > 0 else { return building.initialLife }
        let repairs = building.initialLife / building.repairCycle
        return building.initialLife + repairs * building.extensionPerRepair
    }
}
