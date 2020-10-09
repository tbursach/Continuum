//
//  DateExtension.swift
//  Continuum
//
//  Created by Trevor Bursach on 10/6/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import Foundation

extension Date {
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
    
}
