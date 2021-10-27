//
//  QuoteView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 9/12/21.
//

import SwiftUI
import Firebase

struct QuoteView: View {
    
    @EnvironmentObject private var appViewModel: AppViewModel
    @Environment(\.presentationMode) var presentation //Tells the view to dismiss itself using its presentation mode environment key.
    
    @State private var inquiryText : String = "Quote Request..."
    @State private var selectedPriority : String = "Low"
    
    var placeholderString = "Quote Request..."
    var priorities = ["Low", "Medium", "High"]
    
    var body: some View {
        
        VStack {
            
            VStack {
                Text(appViewModel.userInfo!.name)
                    .foregroundColor(.blue)
                    .font(.system(size: 20, weight: .medium, design: .default))
                Image(uiImage: appViewModel.photoImage!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
            }
            .offset(y: -20)
            
            VStack {
                Text("Priority Level")
                    .padding(.top)
                    .font(.system(size: 20, weight: .ultraLight, design: .rounded))
                
                Picker(selection: $selectedPriority, label: Text("Priority")) {
                    ForEach(priorities, id: \.self){
                        Text("\($0)")
                    }
                }
                .padding()
                .pickerStyle(SegmentedPickerStyle())
                
                TextEditor(text: $inquiryText)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .frame(width: UIScreen.main.bounds.size.width - 50)
                    .frame(maxHeight: .infinity)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.2), lineWidth: 1))
                    .onTapGesture {
                        if inquiryText == placeholderString {
                            inquiryText = ""
                        }
                    }
            }
            
            Button("Submit Request") {
                appViewModel.addTicket(inquiry: inquiryText, priority: selectedPriority, status: "OPEN", type: "Quote")
                self.presentation.wrappedValue.dismiss()
            }
            .frame(width: UIScreen.main.bounds.size.width - 50, height: 70, alignment: .center)
            .font(.title2)
            .background(Color.gray)
            .cornerRadius(15)
            .opacity(0.5)
            
            Spacer()
        }
        .onAppear(){
            UITextView.appearance().backgroundColor = .clear
        }
        
    }
}

struct QuoteView_Previews: PreviewProvider {
    
    static var previews: some View {
        QuoteView()
    }
}
