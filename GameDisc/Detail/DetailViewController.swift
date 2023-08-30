import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var gameDeveloper: UILabel!
    @IBOutlet weak var gameDescription: UILabel!
    @IBOutlet weak var ageRatingImage: UIImageView!
    @IBOutlet weak var gameGenre: UILabel!
    @IBOutlet weak var gameYear: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameScreenshotCollectionView: UICollectionView!
    @IBOutlet weak var screenshotImage: UIImageView!
    @IBOutlet weak var backgroundDescription: UIImageView!
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenshotImage.layer.masksToBounds = true
        screenshotImage.contentMode = .scaleAspectFill
        
        backgroundDescription.layer.cornerRadius = 14
        configure(with: game)
    }
    
    func configure(with game: Game) {
        gameTitle.text = game.name
        gameDescription.text = game.summary
        gameGenre.text = game.genres[0].name
        gameYear.text = String(game.releaseDates[0].y)
        gameRating.text = "⭐ " + String(format: "%.1f", game.rating/10)
        gameDeveloper.text = "Desenvolvido por \(game.involvedCompanies[0].company.name)"
        
        screenshotImage.download(from: game.screenshots[0].imageId) { result in
            print("foi")
        }
        
    }
}
