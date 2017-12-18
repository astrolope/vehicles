//
//  SearchState.swift
//  CandySearch
//
//  Created by Garrett Criss on 12/17/17.
//  Copyright © 2017 GC. All rights reserved.
//

import Foundation

class SearchState {
    
    var isAutomatic:Bool = false;
    var hasSunroof:Bool = false;
    var isFourWheelDrive:Bool = false;
    var hasLowMiles:Bool = false;
    var hasPowerWindows:Bool = false;
    var hasNavigation:Bool = false;
    var hasHeatedSeats:Bool = false;
    
    static let sharedInstance = SearchState()
}
