import UIKit
import swift_vibrant

protocol FeatureGameViewCellDelegate: AnyObject {
    func didTapGame(game: Game)
}

class FeatureGameViewCell: UITableViewCell {
    static let identifier = "FeatureGameView"
    
    weak var delegate: FeatureGameViewCellDelegate?
    private var game: Game?
    
    // MARK: - Components
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 14
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private lazy var verticalStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray6
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray6
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImage.image = nil
    }
    
    // MARK: - Setup

    private func setupView() {
        layer.cornerRadius = 14

        if let image = backgroundImage.image {
            let colorPalette = Vibrant.from(image).getPalette()
            backgroundImage.backgroundColor = colorPalette.Muted?.uiColor.withAlphaComponent(0.5)
            titleLabel.textColor = .white
            genreLabel.textColor = .white
        }
        
        addViewInHierarchy()
        setupConstraints()
        
        backgroundImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openNewPage))
        backgroundImage.addGestureRecognizer(tapGesture)
    }
    
    private func addViewInHierarchy() {
        contentView.addSubview(backgroundImage)
        backgroundImage.addSubview(verticalStack)
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(genreLabel)
    }

    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor, constant: 24),
            verticalStack.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor, constant: -24),
            verticalStack.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -24)
        ])
    }

    // MARK: - Configure
    
    func setGame(_ game: Game) {
        self.game = game
        configure()
    }
    
    private func configure() {
        titleLabel.text = game?.name
        genreLabel.text = game?.genres.first?.name
        if let imagePath = game?.screenshots.first?.imageId {
            backgroundImage.download(from: imagePath, completion: { _ in } )
        }
        
    }
    
    @objc private func openNewPage() {
        guard let game = game else {
            return
        }
        delegate?.didTapGame(game: game)
    }
}
