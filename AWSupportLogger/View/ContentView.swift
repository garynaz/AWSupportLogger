//
//  ContentView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 8/17/21.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel

    
    var body: some View {
        
        NavigationView {
            if viewModel.signedIn {
                
                Text("You are signed in")
                    .navigationBarBackButtonHidden(true)
                    .navigationTitle("AccessWeb")
                    .navigationBarItems(leading: Button(action: {
                        viewModel.signOut()
                    }) {
                        HStack {
                            Text("Sign Out")
                        }
                    })
            } else {
                //.onAppear method is used for keyboard management (See Misc Functions...)
                SignInView()
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            }
        }
        .onAppear {
            viewModel.listen()
        }
    }
}
