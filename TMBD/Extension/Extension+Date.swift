import Foundation
import UIKit

extension MainPresenter {
    func mainDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dataDate = dateFormatter.date(from: date)!

        dateFormatter.dateFormat = "MMM d, yyyy"
        let newStringDate = dateFormatter.string(from: dataDate)
        return newStringDate
    }
}
