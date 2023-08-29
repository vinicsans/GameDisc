import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var gameDeveloper: UILabel!
    @IBOutlet weak var gameDescription: UILabel!
    @IBOutlet weak var ageRatingImage: UIImageView!
    @IBOutlet weak var gameGenre: UILabel!
    @IBOutlet weak var gameYear: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var screenshotImage: UIImageView!
    @IBOutlet weak var backgroundDescription: UIImageView!
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenshotImage.layer.masksToBounds = true
        screenshotImage.contentMode = .scaleAspectFill
        
        backgroundDescription.layer.cornerRadius = 14
        
    }
}
