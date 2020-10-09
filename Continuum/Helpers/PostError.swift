//
//  File.swift
//  Continuum
//
//  Created by Trevor Bursach on 10/6/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import Foundation

enum PostError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    
    var errorDescription: String? {
        switch self {
        
        case .ckError(let error):
            return "There was an error: \(error.localizedDescription)"
        case .couldNotUnwrap:
            return "Unable to unwrap this Post"
        }
    }
}
