//
//  IssueRow.swift
//  Twister
//
//  Created by Isaac Eaton on 5/14/20.
//  Copyright © 2020 Isaac Eaton. All rights reserved.
//

import SwiftUI

struct IssueRow: View {
    
    var issue: Issue
    
    @State var buttonState: ButtonState = .download
    @State var downloadProgress: Float = 0.0
    
    let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM ?yy"
        return formatter
    }()
    
    var body: some View {
        
        VStack {
            HStack {
                Image(uiImage: issue.cover)
                    .resizable()
                    .frame(width: 93, height: 65)
                    .overlay(Rectangle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 3)
                VStack(alignment: .leading) {
                    Text(issue.title)
                        .font(.title)
                        .fontWeight(.semibold)
                    Text(dateFormat.string(from: issue.date).replacingOccurrences(of: "?", with: "\'"))
                        .font(.subheadline)
                }
                .padding(.leading, 3)
                Spacer()
                VStack() {
                    Button(action: {
                        print("Tapped \(self.issue.title)")
                        switch self.buttonState {
                        case .download:
                            self.downloadIssue()
                        case .cancel:
                            self.cancelDownload()
                        case .view:
                            self.buttonState = .download
                        }
                    }) {
                        Text(buttonState.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .buttonStyle(GradientButtonStyle())
                }
            }
            .padding([.top, .horizontal])
            .padding(.bottom, 5)
            
            ProgressBar(value: $downloadProgress)
                .frame(height: 4)
                .opacity(buttonState == .cancel ? 1.0 : 0.0)
        }
        .padding(.horizontal, -15)
        .padding(.bottom, -6)
    }
    
    private func downloadIssue() {
        buttonState = .cancel
        for _ in 0...1000 {
            downloadProgress += 0.001
        }
    }
    
    private func cancelDownload() {
        buttonState = .view
    }
    
}

enum ButtonState:String {
    case download = "Download"
    case cancel = "Cancel"
    case view = "View"
}

struct GradientButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? Color.white : Color.navy)
            .padding(12)
            .frame(minWidth: 85)
            .background(configuration.isPressed ? Color.navy : Color.white)
            .cornerRadius(12)
            //.frame(minWidth: 80)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.navy, lineWidth: 2))
    }
}

extension Color {
    static let navy = Color("Navy")
}
