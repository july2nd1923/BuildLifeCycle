//
//  MaterialInput.swift
//  BuildLifeCycle
//
//  Created by Juliana on 6/3/25.
//

import SwiftUI

// 재료 선택 및 비율 입력 컴포넌트
struct MaterialInput: View {
    @Binding var selectedMaterials: [String: Double]  // 선택된 재료와 비율 (부모와 바인딩)

    // 선택 가능한 재료 리스트
    let materials = ["Reinforced Concrete", "Steel", "Masonry", "Wood"]

    var body: some View {
        Section(header: Text("Select Materials and Enter Ratio (%)")) {
            ForEach(materials, id: \.self) { material in
                HStack {
                    // 재료 선택 토글
                    Toggle(isOn: Binding(
                        get: { selectedMaterials[material] != nil },
                        set: { isSelected in
                            if isSelected {
                                selectedMaterials[material] = 0.0
                            } else {
                                selectedMaterials.removeValue(forKey: material)
                            }
                        }
                    )) {
                        Text(material)
                    }

                    // 비율 입력 필드 (선택된 재료만)
                    if selectedMaterials[material] != nil {
                        Spacer()
                        TextField("Ratio", value: Binding(
                            get: { selectedMaterials[material] ?? 0.0 },
                            set: { selectedMaterials[material] = $0 }
                        ), formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .frame(width: 80)
                        Text("%")
                    }
                }
            }
        }
    }
}
