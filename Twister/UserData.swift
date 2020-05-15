//
//  UserData.swift
//  Twister
//
//  Created by Isaac Eaton on 5/14/20.
//  Copyright © 2020 Isaac Eaton. All rights reserved.
//

import SwiftUI
import Combine

final class UserData: ObservableObject {
    
    @Published var issues = [Issue]()

}
