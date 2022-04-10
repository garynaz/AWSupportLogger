//
//  ReusableAlertView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 04/10/22.
//

import Foundation
import SwiftUI

struct PasswordRecoveryAlertView: View{
	@Environment(\.presentationMode) var presentationMode
	@EnvironmentObject var viewModel: AppViewModel
	@State var color = Color.black.opacity(0.7)

	var body : some View{
		VStack{
			HStack{
				Text("Password Recovery")
					.font(.title)
					.fontWeight(.bold)
					.foregroundColor(self.color)
				
				Spacer()
			}
			.padding(.horizontal, 25)
			
			Text("A password recovery email has been sent successfully!")
				.foregroundColor(self.color)
				.padding(.top)
				.padding(.horizontal, 25)
			
			Button {
				viewModel.recoveryAlert.toggle()
				presentationMode.wrappedValue.dismiss()
			} label: {
				Text("OK")
					.foregroundColor(color)
					.padding(.vertical)
					.frame(width: UIScreen.main.bounds.width - 120)
			}
			.background(Color.white)
			.cornerRadius(10)
			.padding(.top, 25)
			
		}
		.padding(.vertical, 25)
		.frame(width: UIScreen.main.bounds.width - 70)
		.background(.ultraThinMaterial)
		.cornerRadius(15)
	}
	
}
