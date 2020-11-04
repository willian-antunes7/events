import SwiftUI

struct EventRow: View {
    var event: Event
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(event.title)
                Text(formattedDate)
            }
            Spacer()
            Text("$\(String(format: "%.2f", event.price))")
        }.padding()
        
    }
    
    var formattedDate: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(event.date)))
    }
    
}
