//
//  UpdateView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 12/9/21.
//

import SwiftUI

struct UpdateView: View {
    
    @EnvironmentObject private var appViewModel: AppViewModel
    @State var emptyView = true
    
    var body: some View {
        
        ZStack{
            if emptyView{
                Text("No Active Tickets")
                    .opacity(0.5)
                    .foregroundColor(Color(UIColor.systemGray2))
                    .font(.system(size: 30, weight: .semibold, design: .default))
                    .offset(y: -50)
            } else {
                
            }
        }
        
    }
}

struct UpdateView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateView()
    }
}
