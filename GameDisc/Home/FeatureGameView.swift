import UIKit
import swift_vibrant

protocol FeatureGameViewDelegate: AnyObject {
    func didTapCard()
}

class FeatureGameView: UIView {
    
    weak var delegate: FeatureGameViewDelegate?

    // MARK: - Components
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "placeholder1"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 14
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray6
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray6
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openNewPage))
        addGestureRecognizer(tapGesture)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup

    private func setupView() {
        layer.cornerRadius = 14
        
        if let image = backgroundImage.image {
            let colorPalette = Vibrant.from(image).getPalette()
            colorView.backgroundColor = colorPalette.Muted?.uiColor.withAlphaComponent(0.5)
            titleLabel.textColor = .white
            genreLabel.textColor = .white
        }
        
        addViewInHierarchy()
        setupConstraints()
    }
    
    private func addViewInHierarchy() {
        addSubview(backgroundImage)
        addSubview(colorView)
        addSubview(titleLabel)
        addSubview(genreLabel)
    }

    // MARK: - Constraints
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
            genreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            genreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            genreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
        ])
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: topAnchor),
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Configure
    
    func configure(with game: Game) {
        titleLabel.text = game.name
        genreLabel.text = "Ação e Aventura"
    }
    
    @objc private func openNewPage() {
        delegate?.didTapCard()
    }
}
