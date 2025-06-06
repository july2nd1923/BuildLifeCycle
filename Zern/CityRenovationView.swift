//
//  CityRenovationView.swift
//  Zern
//
//  Created by Juliana Lee on 6/6/25.
//

import SwiftUI

// 건물별 생애주기 정보 구조체
struct BuildingLifecycle: Identifiable {
    let id = UUID()
    let name: String              // 건물 이름
    let builtYear: Int           // 준공 연도
    let initialLife: Int         // 초기 생애주기
    let repairCycle: Int         // 보수 주기 (년)
    let extensionPerRepair: Int  // 1회 보수 시 연장 수명 (년)
    let isZEB: Bool              // ZEB 여부
}

struct CityRenovationView: View {
    // 전체 건물 목록
    @State private var buildings: [BuildingLifecycle] = []

    // 입력 폼 상태 변수
    @State private var name = ""
    @State private var builtYear = Calendar.current.component(.year, from: Date())
    @State private var initialLife = ""
    @State private var repairCycle = ""
    @State private var extensionPerRepair = ""
    @State private var isZEB = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🏙 City Renovation Simulator")
                    .font(.title2)
                    .bold()

                // 🔹 건물 입력 폼
                GroupBox(label: Text("Add Building Info").bold()) {
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("Building Name", text: $name)
                        TextField("Year Built", value: $builtYear, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                        TextField("Initial Life (years)", text: $initialLife)
                            .keyboardType(.numberPad)
                        TextField("Repair Cycle (years)", text: $repairCycle)
                            .keyboardType(.numberPad)
                        TextField("Extension per Repair (years)", text: $extensionPerRepair)
                            .keyboardType(.numberPad)
                        Toggle("ZEB Capable", isOn: $isZEB)

                        // ➕ 버튼 클릭 시 리스트에 추가
                        Button("➕ Add Building") {
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

                                // 입력 초기화
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

                // 🔹 타임라인 시각화 영역
                ForEach(buildings) { building in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("🏢 \(building.name)")
                            .font(.headline)

                        GeometryReader { geometry in
                            let totalYears = projectedLife(for: building)
                            let barWidth = geometry.size.width / CGFloat(totalYears)

                            HStack(spacing: 0) {
                                ForEach(0..<totalYears, id: \.self) { yearIndex in
                                    let isRepairYear = building.repairCycle > 0 && yearIndex > 0 && yearIndex % building.repairCycle == 0

                                    Rectangle()
                                        .fill(
                                            isRepairYear ? Color.orange :
                                            (building.isZEB ? Color.green.opacity(0.8) : Color.gray.opacity(0.5))
                                        )
                                        .frame(width: barWidth, height: 18)
                                }
                            }
                        }
                        .frame(height: 20)

                        // 건물 설명 텍스트
                        HStack {
                            Text("Built: \(building.builtYear)")
                            Text("Estimated Lifespan: \(projectedLife(for: building)) years")
                            Text(building.isZEB ? "ZEB Capable" : "Not ZEB")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("City Renovation")
    }

    // 🔧 보수를 고려한 생애주기 계산 함수
    func projectedLife(for building: BuildingLifecycle) -> Int {
        guard building.repairCycle > 0 else { return building.initialLife }
        let repairs = building.initialLife / building.repairCycle
        return building.initialLife + repairs * building.extensionPerRepair
    }
}
