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
                    Text("Priority Level")
                        .padding(.top)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    Picker(selection: $selectedPriority, label: Text("Priority")) {
                        ForEach(priorities, id: \.self){
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    TextEditor(text: $inquiryText)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .foregroundColor(.primary)
                        .frame(width: UIScreen.main.bounds.size.width - 20)
                        .frame(maxHeight: .infinity)
                        .background(Color.black)
                        .border(Color.gray)
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
                .frame(width: UIScreen.main.bounds.size.width, height: 70, alignment: .center)
                .font(.title2)
                .background(Color.gray)
                .opacity(0.8)
            }
    }
}

struct QuoteView_Previews: PreviewProvider {

    static var previews: some View {
        QuoteView()
    }
}
