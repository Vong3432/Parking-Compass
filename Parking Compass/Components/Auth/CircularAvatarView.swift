//
//  CircularAvatarView.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 01/03/2022.
//

import SwiftUI

struct CircularAvatarView: View {
    let user: User
    
    var body: some View {
        Circle()
            .fill(.gray)
            .frame(width: 42, height: 42)
            .overlay {
                Text(user.email?.firstChar() ?? "Unknown")
                    .foregroundColor(.white)
            }
    }
}

struct CircularAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        CircularAvatarView(user: User(uniqueId: "asd", email: "asd", username: "Sasd"))
            .previewLayout(.sizeThatFits)
    }
}
