//
//  LifeCyclePredictor.swift
//  BuildLifeCycle
//
//  Created by Juliana Lee on 6/3/25.
//
import Foundation

struct LifeCyclePredictor {
    static func predict(yearBuilt: String, material: String, usage: String, floors: Int) -> Int {
        guard let builtYear = Int(yearBuilt) else { return 0 }
        
        var baseLife = 50
        if material == "철골" { baseLife = 40 }
        else if material == "조적" { baseLife = 35 }
        else if material == "목조" { baseLife = 30 }
        
        if usage == "공공시설" { baseLife += 10 }
        if floors >= 10 { baseLife += 5 }
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let age = currentYear - builtYear
        
        return max(baseLife - age, 0)
    }
}

