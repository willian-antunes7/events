import SwiftUI

struct CircleImage: View {
    var image: Image

    var body: some View {
        image.resizable()
        .scaledToFill()
            .clipShape(Circle())
            .frame(width: 224, height: 224, alignment: .center)
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image(systemName: "camera.circle.fill"))
    }
}
