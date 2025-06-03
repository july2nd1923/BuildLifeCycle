//
//  MaterialInput.swift
//  BuildLifeCycle
//
//  Created by 김재현 on 6/3/25.
//
import SwiftUI

struct MaterialInput: View {
    @Binding var selectedMaterials: [String: Double]
    
    let materials = ["철근콘크리트", "철골", "조적", "목조"]
    
    var body: some View {
        Section(header: Text("재료 선택 및 비율 입력 (%)")) {
            ForEach(materials, id: \.self) { material in
                HStack {
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
                    
                    if selectedMaterials[material] != nil {
                        Spacer()
                        TextField("비율", value: Binding(
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
