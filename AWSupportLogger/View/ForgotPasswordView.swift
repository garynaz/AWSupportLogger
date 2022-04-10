//
//  ForgotPasswordView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 4/10/22.
//

import SwiftUI

struct ForgotPasswordView: View {
	
	@EnvironmentObject var viewModel: AppViewModel
	@State private var recoveryEmail : String = ""

	var body: some View {
		ZStack{
			VStack{
				Text("Forgot Password")
					.font(.system(size: 30))
				
				Text("Please enter the email you used at the time of registration to receive the password reset instructions.")
					.multilineTextAlignment(.center)
					.padding()
				
				TextField("Please enter in your email...", text: $recoveryEmail)
					.padding()
					.background(RoundedRectangle(cornerRadius: 4).stroke(Color(UIColor.systemGray2), lineWidth: 1))
					.disableAutocorrection(true)
					.autocapitalization(.none)
					.padding(.horizontal, 25)
					.padding(.bottom)
				
				Button(action: {
					viewModel.sendPasswordRecoveryInstruction(email: recoveryEmail)
				}, label: {
					Text("Reset Password")
						.frame(width: 300, height: 50)
						.foregroundColor(Color.themeBackground)
						.background(Color.themeAccent)
						.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
				})

				Spacer()
			}
			
			if viewModel.alert{
				ErrorView(error: viewModel.error)
			} else if viewModel.recoveryAlert {
				PasswordRecoveryAlertView()
			}
			
		}
		
	}
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
