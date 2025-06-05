//
//  CarbonDatabase.swift
//  BuildLifeCycle
//
//  Created by 김재현 on 6/3/25.
//
// ✅ 2. CarbonDatabase.swift
import Foundation

struct CarbonDatabase {
    static let unitEmissions: [String: Double] = [
        "철근콘크리트": 300,
        "철골": 11000,
        "조적": 500,
        "목조": 150
    ]

    static let unitCarbonPerArea: [String: Double] = [
        "철근콘크리트": 320.0,
        "철골": 980.0,
        "조적": 250.0,
        "목조": 120.0
    ]
}
