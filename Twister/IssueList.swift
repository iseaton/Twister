//
//  IssueList.swift
//  Twister
//
//  Created by Isaac Eaton on 5/14/20.
//  Copyright © 2020 Isaac Eaton. All rights reserved.
//

import SwiftUI

struct IssueList: View {
    
    @EnvironmentObject var userData: UserData
    
    
    
    var body: some View {
        
       // NavigationView {
            List {
                ForEach(userData.issues) { issue in
                    IssueRow(issue: issue)
                }
            }
    }
}
