//
//  SupportView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 9/12/21.
//

import SwiftUI
import Firebase

struct SupportView: View {
    
    @EnvironmentObject private var appViewModel: AppViewModel
    @Environment(\.presentationMode) var presentation //Tells the view to dismiss itself using its presentation mode environment key.
    
    @State private var inquiryText : String = "Enter Your Inquiry..."
    @State private var selectedPriority : String = "Low"
    
    var placeholderString = "Enter Your Inquiry..."
    var priorities = ["Low", "Medium", "High"]
    
    
    var body: some View {
        
        VStack {
            
            VStack {
                Text(appViewModel.userInfo!.name)
                    .foregroundColor(.blue)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                Image(uiImage: appViewModel.photoImage!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
            }
            .offset(y: -20)
            
            VStack {
                VStack {
                    Text("Priority")
                        .font(.system(size: 20, weight: .light, design: .rounded))
                    Picker(selection: $selectedPriority, label: Text("Priority")) {
                        ForEach(priorities, id: \.self){
                            Text("\($0)")
                        }
                    }
                    .padding(.horizontal, 50)
                    .pickerStyle(SegmentedPickerStyle())
                    .colorMultiply(Color.blue)
                }
                
                
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
            Button("Submit Ticket") {
                appViewModel.addTicket(inquiry: inquiryText, priority: selectedPriority, status: "OPEN", type: "Support")
                self.presentation.wrappedValue.dismiss()
            }
            .frame(width: UIScreen.main.bounds.size.width - 50, height: 70, alignment: .center)
            .font(.title2)
            .background(Color.gray)
            .cornerRadius(15)
            .opacity(0.5)
            
            Spacer()
        }
    }
    
}

struct SupportView_Previews: PreviewProvider {
    
    static var previews: some View {
        SupportView()
    }
}
