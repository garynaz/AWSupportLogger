//
//  ErrorView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 10/24/21.
//

import Foundation
import SwiftUI

struct ErrorView: View{
    @EnvironmentObject var viewModel: AppViewModel
    
    @State var color = Color.black.opacity(0.7)
    var error: String?
    
    var body : some View{
        VStack{
            HStack{
                Text("Error")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.themeForeground)
                
                Spacer()
            }
            .padding(.horizontal, 25)
            
            Text(self.error!)
				.foregroundColor(Color.themeForeground)
                .padding(.top)
                .padding(.horizontal, 25)
            
            Button {
                viewModel.alert.toggle()
            } label: {
                Text("Cancel")
                    .foregroundColor(Color.themeForeground)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 120)
            }
            .background(Color.themeBackground)
            .cornerRadius(10)
            .padding(.top, 25)
            
        }
        .padding(.vertical, 25)
        .frame(width: UIScreen.main.bounds.width - 70)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
    
}
