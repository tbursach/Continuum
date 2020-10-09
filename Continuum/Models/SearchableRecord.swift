//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Trevor Bursach on 10/7/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func searchForWordThatMatches(searchTerm: String) -> Bool
}
