//
//  BarChartView.swift
//  BuildLifeCycle
//
//  Created by 김재현 on 6/3/25.
//
import SwiftUI
import Charts

struct BarChartView: View {
    var stages: [(label: String, value: Int)]

    var body: some View {
        Chart {
            ForEach(stages, id: \.label) { stage in
                BarMark(
                    x: .value("단계", stage.label),
                    y: .value("수명", stage.value)
                )
                .foregroundStyle(.blue)
            }
        }
        .frame(height: 250)
        .padding()
    }
}
