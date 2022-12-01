import Foundation

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

extension MoviePresenter {
    func mainDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dataDate = dateFormatter.date(from: date)!

        dateFormatter.dateFormat = "yyyy"
        let newStringDate = dateFormatter.string(from: dataDate)
        return newStringDate
    }
    
    func mainTime(_ time: Int) -> String {
        let hour = time / 60 % 60
        let minute = time % 60
        if hour == 0 {
            return String(format: "\(minute) min")
        } else {
            return String(format: "\(hour) h \(minute) min")
        }
    }
}

extension SerialPresenter {
    func mainDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dataDate = dateFormatter.date(from: date)!

        dateFormatter.dateFormat = "yyyy"
        let newStringDate = dateFormatter.string(from: dataDate)
        return newStringDate
    }
}

