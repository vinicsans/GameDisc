import UIKit
import swift_vibrant

extension UIImageView {
    
    func download(from imagePath: String) {
        var url = URL(string: "https://images.igdb.com/igdb/image/upload/t_screenshot_med/")!
        url.append(path: "\(imagePath).png")

        URLSession.shared.dataTask(with: .init(url: url)) { data, _, error in
            if error != nil { return }

            if let data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            } else { return }
        }.resume()
    }
}
