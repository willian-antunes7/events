import SwiftUI

struct PersonRow: View {
    var person: Person
    
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
            Text(person.name)
        }
    }
}

struct PersonRow_Previews: PreviewProvider {
    static var previews: some View {
        PersonRow(person: Person(id: "1", eventId: "1", name: "John Doe", picture: "NA"))
    }
}
