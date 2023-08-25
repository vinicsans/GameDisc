import UIKit
import swift_vibrant

class TileCollectionViewCell: UICollectionViewCell {
    static let identifier = "TileCollectionViewCell"

    // MARK: - Componentes
    
    private let gameImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 14
        image.backgroundColor = .systemGray6
        return image
    }()
    
    private let colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 14
        return colorView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray6
        return label
    }()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(gameImage)
        contentView.addSubview(colorView)
        contentView.addSubview(label)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorView.frame = contentView.frame
    }

    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            gameImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            gameImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gameImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gameImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    // MARK: - Configure
  
    func configure(with viewModel: Game) {
        if let imageId = viewModel.screenshots.first {
                NetworkManager.shared.fetchScreenshot(imageId: imageId) { result in
                    switch result {
                    case .success(let screenshots):
                        if let imagePath = screenshots.first?.imageId {
                            self.gameImage.download(from: imagePath)
                        }
                    case .failure(let error):
                        print("Error fetching screenshot: \(error)")
                    }
                }
            }
        if let image = gameImage.image {
            let colorPalette = Vibrant.from(image).getPalette()
            colorView.backgroundColor = colorPalette.Muted?.uiColor.withAlphaComponent(0.5)
            label.textColor = .white
        }
        
        label.text = viewModel.name
        
        contentView.contentMode = .scaleAspectFill
        contentView.layer.cornerRadius = 14
    }

}
