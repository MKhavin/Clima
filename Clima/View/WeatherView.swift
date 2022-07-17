import UIKit

class WeatherView: UIView {
    // MARK: UI Elements
    lazy var backgroundImageView: UIImageView = {
        let imageName = traitCollection.userInterfaceStyle == .dark ? "backgroundDark" : "backgroundLight"
        let view = UIImageView(image: UIImage(named: imageName))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Search"
        view.backgroundImage = UIImage()
        view.backgroundColor = .clear
        view.barTintColor = .clear
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.alignment = .trailing
        view.spacing = 10
        view.axis = .vertical
        return view
    }()
    
    private lazy var topBarStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var searchCurrentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.circle.fill"),
                        for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"),
                        for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var weatherConditionImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "sun.max"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .label
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var cityLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "City"
        view.font = UIFont.systemFont(ofSize: 30)
        return view
    }()
    
    private lazy var temperatureStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 0
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()
    
    lazy var temperatureLabel: UILabel = {
        let view = UILabel()
        view.text = "21"
        view.font = .systemFont(ofSize: 80, weight: .black)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var temperatureSymbol: UILabel = {
        let view = UILabel()
        view.text = "°"
        view.font = UIFont.systemFont(ofSize: 100, weight: .light)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var temperatureMesuareLabel: UILabel = {
        let view = UILabel()
        view.text = "C"
        view.font = UIFont.systemFont(ofSize: 100, weight: .light)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([
            backgroundImageView,
            topBarStackView,
            mainStackView
        ])
        setUpTopBarStackView()
        setUpMainStackView()
        setUpSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: Sub functions
extension WeatherView {
    private func setUpSubviewsLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            topBarStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5),
            topBarStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -5),
            topBarStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topBarStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            searchCurrentLocationButton.widthAnchor.constraint(equalToConstant: 40),
            searchCurrentLocationButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            weatherConditionImageView.widthAnchor.constraint(equalToConstant: 120),
            weatherConditionImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topBarStackView.bottomAnchor, constant: 5),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setUpTopBarStackView() {
        topBarStackView.addArrangedSubview(searchCurrentLocationButton)
        topBarStackView.addArrangedSubview(searchBar)
        topBarStackView.addArrangedSubview(searchButton)
    }
    
    private func setUpMainStackView() {
        mainStackView.addArrangedSubview(weatherConditionImageView)
        mainStackView.addArrangedSubview(temperatureStackView)
        mainStackView.addArrangedSubview(cityLabel)
        
        setUpTemperatureStackView()
    }
    
    private func setUpTemperatureStackView() {
        temperatureStackView.addArrangedSubview(temperatureLabel)
        temperatureStackView.addArrangedSubview(temperatureSymbol)
        temperatureStackView.addArrangedSubview(temperatureMesuareLabel)
    }
}
