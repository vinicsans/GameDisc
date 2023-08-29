import UIKit
import swift_vibrant

class TileCollectionViewCell: UICollectionViewCell {
    static let identifier = "TileCollectionViewCell"

    private let gameImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 14
        image.backgroundColor = .systemGray6
        image.alpha = 0.0 // Começa totalmente transparente
        return image
    }()
    
    private let colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 14
        colorView.alpha = 0.0 // Começa totalmente transparente
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

    override func layoutSubviews() {
        super.layoutSubviews()
        colorView.frame = contentView.frame
    }
    
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
    
    override func prepareForReuse() {
        gameImage.image = nil
        gameImage.alpha = 0.0 // Volta à transparência total ao ser reutilizado
        label.text = nil
        colorView.backgroundColor = .clear
        colorView.alpha = 0.0 // Volta à transparência total ao ser reutilizado
    }

    func configure(with viewModel: Game) {
        setupUI()
        fetchAndDisplayScreenshot(for: viewModel)
        setupLabel(with: viewModel.name)
    }

    private func setupUI() {
        contentView.contentMode = .scaleAspectFill
        contentView.layer.cornerRadius = 14
    }

    private func fetchAndDisplayScreenshot(for viewModel: Game) {
        guard let imageId = viewModel.screenshots.first else { return }
        
        NetworkManager.shared.fetchScreenshot(imageId: imageId) { [weak self] result in
            switch result {
            case .success(let screenshots):
                self?.handleScreenshotFetchResult(screenshots.first)
            case .failure(let error):
                print("Error fetching screenshot: \(error)")
            }
        }
    }

    private func handleScreenshotFetchResult(_ screenshot: Screenshot?) {
        guard let imagePath = screenshot?.imageId else { return }
        
        gameImage.download(from: imagePath) { [weak self] imageResult in
            switch imageResult {
            case .success(let image):
                self?.handleImageDownloadResult(image)
            case .failure(let error):
                print("Error downloading image: \(error)")
            }
        }
    }

    private func handleImageDownloadResult(_ image: UIImage?) {
        guard let image = image else { return }
        
        let colorPalette = Vibrant.from(image).getPalette()
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.colorView.backgroundColor = colorPalette.Muted?.uiColor.withAlphaComponent(0.5)
                self?.colorView.alpha = 1.0 // Faz a colorView totalmente visível
                
                self?.gameImage.image = image
                self?.gameImage.alpha = 1.0 // Faz a gameImage totalmente visível
            }
        }
    }

    private func setupLabel(with text: String) {
        label.text = text
    }
}
