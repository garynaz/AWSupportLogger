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

        VStack{
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "building.2.crop.circle")
                        .font(.system(size: 40))
                    Text(appViewModel.userInfo!.company)
                        .disabled(true)
                }

                HStack {
                    Image(systemName: "person.circle")
                        .font(.system(size: 40))
                    Text(appViewModel.userInfo!.name)
                        .disabled(true)
                }
            }

            VStack {
                VStack {
                    Text("Priority Level")
                        .padding(.top)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    Picker(selection: $selectedPriority, label: Text("Priority")) {
                        ForEach(priorities, id: \.self){
                            Text("\($0)")
                        }
                    }
                    .padding()
                    .pickerStyle(SegmentedPickerStyle())
                }


                TextEditor(text: $inquiryText)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .frame(width: UIScreen.main.bounds.size.width - 50)
                    .frame(maxHeight: .infinity)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(Color.black.opacity(0.5), lineWidth: 2))
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
