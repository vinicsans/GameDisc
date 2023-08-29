import UIKit

extension UIImageView {
    private static let imageCache = NSCache<NSString, UIImage>()

    func download(from imagePath: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        if let cachedImage = UIImageView.imageCache.object(forKey: imagePath as NSString) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            completion(.success(cachedImage))
            return
        }

        guard let url = URL(string: "https://images.igdb.com/igdb/image/upload/t_screenshot_med/\(imagePath).png") else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            if let data = data, let image = UIImage(data: data) {
                UIImageView.imageCache.setObject(image, forKey: imagePath as NSString)
                DispatchQueue.main.async {
                    self.image = image
                    completion(.success(image))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.success(nil))
                }
            }
        }.resume()
    }
}
