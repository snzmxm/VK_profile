//
//  ViewController.swift
//  VK_profile
//
//  Created by SNZ on 02.02.2022.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: - Elements

    private lazy var image: UIImageView = {
    let imageView = UIImageView()

    imageView.image = UIImage (named: Icons.avatarButtonIcon)
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 300

    return imageView
    }()

    //Создание кнопки c фото
    private lazy var avatarButton: UIButton = {
        let avatarButton = UIButton()

//        let image = UIImage(named: Icons.avatarButtonIcon)
        avatarButton.setImage(image.image, for: .normal)
        avatarButton.layer.masksToBounds = true
        avatarButton.layer.cornerRadius = 40

        return avatarButton
    }()

    //Создание имени и фамилии
    private lazy var myNameLabel: UILabel = {
        let myNameLabel = UILabel()

        myNameLabel.text = Strings.myNameButtonText
        myNameLabel.font = .systemFont(ofSize: 25)
        myNameLabel.textColor = Colors.whiteColor
        myNameLabel.adjustsFontSizeToFitWidth = true

        return myNameLabel
    }()

    //Создание статуса
    private lazy var statusButton: UILabel = {
        let statusLabel = UILabel()

        statusLabel.text = Strings.statusLabelText
        statusLabel.font = .systemFont(ofSize: Metric.size20)
        statusLabel.textColor = Colors.whiteColor
        statusLabel.adjustsFontSizeToFitWidth = true

        return statusLabel
    }()

    //Создание лейбла сетевого статуса
    private lazy var networkStatusLabel: UILabel = {
        let networkStatusLabel = UILabel()

        networkStatusLabel.text = Strings.networkStatusLabelText
        networkStatusLabel.font = .systemFont(ofSize: Metric.size13, weight: .medium)
        networkStatusLabel.textColor = Colors.lightGrayColor
        networkStatusLabel.adjustsFontSizeToFitWidth = true

        //Добавление иконки телефона
        let imageAttachment = NSTextAttachment()
        let smallConfig = UIImage.SymbolConfiguration(pointSize: Metric.size15, weight: .medium, scale: .small)
        imageAttachment.image = UIImage(systemName: Icons.networkStatusLabelIcon, withConfiguration: smallConfig)?.withTintColor(.white)
        let fullString = NSMutableAttributedString(string: networkStatusLabel.text ?? "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        networkStatusLabel.attributedText = fullString

        return networkStatusLabel
    }()


    //Создание кнопки редактировать
    private lazy var editButton: UIButton = {
        let editButton = UIButton(type: .system)

        editButton.setTitle(Strings.editButtonText, for: .normal)
        editButton.setTitleColor(Colors.whiteColor, for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: Metric.size15, weight: .medium)
        editButton.backgroundColor = Colors.grayColor
        editButton.titleLabel?.textAlignment = .center
        editButton.titleLabel?.adjustsFontSizeToFitWidth = true
        editButton.layer.cornerRadius = Metric.size10

        return editButton
    }()

    //Создание разделителя
    private lazy var separatorViewOne: UIView = {
        let separatorViewOne = UIView()

        separatorViewOne.backgroundColor = Colors.lightGrayColor

        return separatorViewOne
    }()

    private lazy var separatorViewTwo: UIView = {
        let separatorViewTwo = UIView()

        separatorViewTwo.backgroundColor = Colors.lightGrayColor

        return separatorViewTwo
    }()

    //Аватарки моих корешей
    var friends = Icons.friendsAvatars

    //Создание кнопок с добавлением контента
    private lazy var storiesButton = createContentButtons(with: Strings.storiesButtonText, icon: Icons.storiesButtonIcon)
    private lazy var postButton = createContentButtons(with: Strings.postButtonText, icon: Icons.postButtonIcon)
    private lazy var photoButton = createContentButtons(with: Strings.photoButtonText, icon: Icons.photoButtonIcon)
    private lazy var clipButton = createContentButtons(with: Strings.clipButtonText, icon: Icons.clipButtonIcon)

    //Cоздание маленьких иконок
    private lazy var checkmark = smallIcons(colorTitle: Colors.blueColor, icon: Icons.checkmarkIcon, iconSize: Metric.size10)
    private lazy var forwardArrow = smallIcons(colorTitle: Colors.purpleColor, icon: Icons.forwardArrow, iconSize: Metric.size15)

    //Создание StackView с кнопками добавления контента
    private lazy var addContentStackView: UIStackView = {
        let addContentStackView = UIStackView()

        addContentStackView.axis = .horizontal
        addContentStackView.distribution = .equalSpacing

        return addContentStackView
    }()

    //Создание StackView с друзьями
    private lazy var addFriendsStackView: UIStackView = {
        let addFriendsStackView = UIStackView()

        addFriendsStackView.axis = .horizontal
        addFriendsStackView.distribution = .equalSpacing

        return addFriendsStackView
    }()


    //Создание StackView с кнопками информации о пользователе
    private lazy var infoButtonsStackView: UIStackView = {
        let infoButtonsStackView = UIStackView()

        infoButtonsStackView.axis = .vertical
        infoButtonsStackView.alignment = .leading
        infoButtonsStackView.distribution = .equalSpacing

        return infoButtonsStackView
    }()

    private lazy var cityButton = createInfoButtons(with: Strings.cityButtonText,
                                                    colorTitle: Colors.lightGrayColor,
                                                    icon: Icons.cityButtonIcon,
                                                    iconSize: Metric.size15)

    private lazy var subscribersButton = createInfoButtons(with: Strings.subscribersButtonText,
                                                           colorTitle: Colors.lightGrayColor,
                                                           icon: Icons.subscribersButtonIcon,
                                                           iconSize: Metric.size18)

    private lazy var placeOfWorkButton = createInfoButtons(with: Strings.placeOfWorkButtonText,
                                                           colorTitle: Colors.blueColor,
                                                           icon: Icons.placeOfWorkButtonIcon,
                                                           iconSize: Metric.size15)

    private lazy var giftButton = createInfoButtons(with: Strings.giftButtonText,
                                                    colorTitle: Colors.purpleColor,
                                                    icon: Icons.giftButtonIcon,
                                                    iconSize: Metric.size19)

    private lazy var detailedInfoButton = createInfoButtons(with: Strings.detailedInfoButtonText,
                                                            colorTitle: Colors.whiteColor,
                                                            icon: Icons.detailedInfoButtonIcon,
                                                            iconSize: Metric.size18)

    private lazy var friendsButton = createInfoButtons(with: Strings.friendsLabelText,
                                                       colorTitle: .white,
                                                       icon: nil,
                                                       iconSize: nil)

    //MARK: - Lifecycle

    //Вызов загрузочного View
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupView()
        navigationBar()
        collectionViewFriends()
    }

    //MARK: - Settings

    //Добавление элементов на главную View
    private func setupHierarchy() {
        view.addSubview(avatarButton)
        view.addSubview(myNameLabel)
        view.addSubview(statusButton)
        view.addSubview(networkStatusLabel)
        view.addSubview(editButton)
        view.addSubview(checkmark)
        view.addSubview(forwardArrow)
        view.addSubview(image)

        view.addSubview(addContentStackView)
        addContentStackView.addArrangedSubview(storiesButton)
        addContentStackView.addArrangedSubview(postButton)
        addContentStackView.addArrangedSubview(photoButton)
        addContentStackView.addArrangedSubview(clipButton)

        view.addSubview(separatorViewOne)
        view.addSubview(separatorViewTwo)

        view.addSubview(infoButtonsStackView)
        infoButtonsStackView.addArrangedSubview(cityButton)
        infoButtonsStackView.addArrangedSubview(subscribersButton)
        infoButtonsStackView.addArrangedSubview(placeOfWorkButton)
        infoButtonsStackView.addArrangedSubview(giftButton)
        infoButtonsStackView.addArrangedSubview(detailedInfoButton)

        view.addSubview(addFriendsStackView)
        addFriendsStackView.addArrangedSubview(friendsButton)
    }

    //Привязка констрейнтов
    private func setupLayout() {

        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                          constant: Offsets.constr5).isActive = true
        avatarButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                           constant: Offsets.constr15).isActive = true
        avatarButton.widthAnchor.constraint(equalTo: view.widthAnchor,
                                            multiplier: Offsets.constr020).isActive = true
        avatarButton.widthAnchor.constraint(equalTo: avatarButton.heightAnchor,
                                            multiplier: Offsets.constr1).isActive = true


        myNameLabel.translatesAutoresizingMaskIntoConstraints = false
        myNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                         constant: Offsets.constr15).isActive = true
        myNameLabel.leftAnchor.constraint(equalTo: avatarButton.rightAnchor,
                                          constant: Offsets.constr15).isActive = true
        myNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor,
                                           multiplier: Offsets.constr037).isActive = true
        myNameLabel.heightAnchor.constraint(equalTo: view.widthAnchor,
                                            multiplier: Offsets.constr006).isActive = true


        statusButton.translatesAutoresizingMaskIntoConstraints = false
        statusButton.topAnchor.constraint(equalTo: myNameLabel.bottomAnchor,
                                          constant: Offsets.constr0).isActive = true
        statusButton.leftAnchor.constraint(equalTo: avatarButton.rightAnchor,
                                           constant: Offsets.constr15).isActive = true
        statusButton.widthAnchor.constraint(equalTo: view.widthAnchor,
                                            multiplier: Offsets.constr033).isActive = true
        statusButton.heightAnchor.constraint(equalTo: view.widthAnchor,
                                             multiplier: Offsets.constr006).isActive = true


        networkStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        networkStatusLabel.topAnchor.constraint(equalTo: statusButton.bottomAnchor,
                                                constant: Offsets.constr0).isActive = true
        networkStatusLabel.leftAnchor.constraint(equalTo: avatarButton.rightAnchor,
                                                 constant: Offsets.constr15).isActive = true
        networkStatusLabel.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                  multiplier: Offsets.constr0157).isActive = true
        networkStatusLabel.heightAnchor.constraint(equalTo: view.widthAnchor,
                                                   multiplier: Offsets.constr005).isActive = true


        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.topAnchor.constraint(equalTo: networkStatusLabel.bottomAnchor,
                                        constant: Offsets.constr20).isActive = true
        editButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                         constant: Offsets.constr15).isActive = true
        editButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                          constant: Offsets.constrMinus15).isActive = true
        editButton.heightAnchor.constraint(equalTo: view.widthAnchor,
                                           multiplier: Offsets.constr0098).isActive = true
        editButton.titleLabel?.heightAnchor.constraint(equalTo: view.widthAnchor,
                                                       multiplier: Offsets.constr0045).isActive = true


        addContentStackView.translatesAutoresizingMaskIntoConstraints = false
        addContentStackView.topAnchor.constraint(equalTo: editButton.bottomAnchor,
                                                 constant: Offsets.constr15).isActive = true
        addContentStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                  constant: Offsets.constr20).isActive = true
        addContentStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                   constant: Offsets.constrMinus20).isActive = true
        addContentStackView.heightAnchor.constraint(equalTo: view.widthAnchor,
                                                    multiplier: Offsets.constr015).isActive = true


        separatorViewOne.translatesAutoresizingMaskIntoConstraints = false
        separatorViewOne.topAnchor.constraint(equalTo: addContentStackView.bottomAnchor,
                                              constant: Offsets.constr10).isActive = true
        separatorViewOne.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                               constant: Offsets.constr15).isActive = true
        separatorViewOne.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                constant: Offsets.constr15).isActive = true
        separatorViewOne.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                multiplier: Offsets.constr092).isActive = true
        separatorViewOne.heightAnchor.constraint(equalToConstant: Offsets.constr05).isActive = true


        separatorViewTwo.translatesAutoresizingMaskIntoConstraints = false
        separatorViewTwo.topAnchor.constraint(equalTo: infoButtonsStackView.bottomAnchor,
                                              constant: Offsets.constr15).isActive = true
        separatorViewTwo.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                               constant: Offsets.constr15).isActive = true
        separatorViewTwo.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                constant: Offsets.constr15).isActive = true
        separatorViewTwo.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                multiplier: Offsets.constr092).isActive = true
        separatorViewTwo.heightAnchor.constraint(equalToConstant: Offsets.constr05).isActive = true


        friendsButton.translatesAutoresizingMaskIntoConstraints = false
        friendsButton.topAnchor.constraint(equalTo: separatorViewTwo.bottomAnchor,
                                           constant: Offsets.constr10).isActive = true
        friendsButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                            constant: Offsets.constrMinus20).isActive = true
        friendsButton.widthAnchor.constraint(equalTo: view.widthAnchor,
                                             multiplier: Offsets.constr037).isActive = true
        friendsButton.heightAnchor.constraint(equalTo: view.widthAnchor,
                                              multiplier: Offsets.constr006).isActive = true


        infoButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        infoButtonsStackView.topAnchor.constraint(equalTo: separatorViewOne.bottomAnchor,
                                                  constant: Offsets.constr15).isActive = true
        infoButtonsStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                   constant: Offsets.constr15).isActive = true
        infoButtonsStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                    constant: Offsets.constr15).isActive = true
        infoButtonsStackView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                    multiplier: Offsets.constr092).isActive = true
        infoButtonsStackView.heightAnchor.constraint(equalTo: view.widthAnchor,
                                                     multiplier: Offsets.constr04).isActive = true


        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                       constant: Offsets.constr9).isActive = true
        checkmark.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                        constant: Offsets.constr120).isActive = true
        checkmark.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                         constant: Offsets.constr25).isActive = true
        checkmark.heightAnchor.constraint(equalTo: view.widthAnchor,
                                          multiplier: Offsets.constr0098).isActive = true


        forwardArrow.translatesAutoresizingMaskIntoConstraints = false
        forwardArrow.topAnchor.constraint(equalTo: placeOfWorkButton.bottomAnchor,
                                          constant: Offsets.constr15).isActive = true
        forwardArrow.leftAnchor.constraint(equalTo: giftButton.rightAnchor,
                                           constant: Offsets.constr5).isActive = true
        forwardArrow.bottomAnchor.constraint(equalTo: detailedInfoButton.topAnchor, constant: Offsets.constrMinus15).isActive = true

    }

    //Цвет бэка
    private func setupView() {
        view.backgroundColor = Colors.backgroundColor
    }

    //Настройки навигационного бара
    private func navigationBar() {
        title = "snznsk"
        view.addSubview(statusButton)
    }


    //MARK: - Create functions

    //Создание кнопок с контентом
    private func createContentButtons(with title: String, icon: String) -> UIButton {

        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: Metric.size14, weight: .semibold)
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(title, attributes: container)
        configuration.image = UIImage(systemName: icon)
        configuration.imagePlacement = .top
        configuration.imagePadding = Metric.size15
        configuration.baseForegroundColor = Colors.blueColor
        let button = UIButton(configuration: configuration, primaryAction: nil)

        return button
    }

    //Создание StackView с друзьями(Тестил на Iphone 13 pro) Пока что не разобрался, как привязать констрейнтами кнопки сделал через viewDidLayoutSubviews
    private var collectionView: UICollectionView?

    private func collectionViewFriends() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: Metric.size50, height: Metric.size50)
        layout.sectionInset = UIEdgeInsets(top: Metric.size0, left: Metric.size0, bottom: Metric.size0, right: Metric.size0)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(CircleCollectionViewCell.self, forCellWithReuseIdentifier: CircleCollectionViewCell.identifier)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = Colors.backgroundColor
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let myCollection = collectionView else{
            return
        }
        view.addSubview(myCollection)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = CGRect(x: Metric.size0, y: Metric.size550, width: view.frame.size.width, height: Metric.size50).integral
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return Icons.friendsAvatars.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleCollectionViewCell.identifier, for: indexPath) as! CircleCollectionViewCell

        cell.configure(with: friends[indexPath.row])

        return cell
    }
}

//Добавление маленьких иконок
private func smallIcons(colorTitle: UIColor, icon: String?, iconSize: CGFloat?) -> UIButton {
    let icons = UIButton(type: .system)
    icons.setTitleColor(colorTitle, for: .normal)
    icons.titleLabel?.adjustsFontSizeToFitWidth = true

    if icon != nil {
        let mediumConfig = UIImage.SymbolConfiguration(pointSize: iconSize ?? 0 , weight: .medium, scale: .medium)
        icons.setImage(UIImage(systemName: icon ?? "" , withConfiguration: mediumConfig), for: .normal)
        icons.tintColor = colorTitle
    }

    return icons
}

//Функция создания кнопок с информацией о пользователе и кнопки с установкой статуса
private func createInfoButtons(with title: String, colorTitle: UIColor, icon: String?, iconSize: CGFloat?) -> UIButton {
    let button = UIButton(type: .system)

    button.setTitle(title, for: .normal)
    button.setTitleColor(colorTitle, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
    button.titleLabel?.adjustsFontSizeToFitWidth = true

    if icon != nil {
        let mediumConfig = UIImage.SymbolConfiguration(pointSize: iconSize ?? 0, weight: .medium, scale: .medium)
        button.setImage(UIImage(systemName: icon ?? "", withConfiguration: mediumConfig), for: .normal)
        button.tintColor = colorTitle
    }
    return button
}


//MARK: - Constants

extension ViewController {

    //Размеры
    enum Metric {
        static let size40: CGFloat = 40
        static let size20: CGFloat = 20
        static let size15: CGFloat = 15
        static let size13: CGFloat = 13
        static let size10: CGFloat = 10
        static let size12: CGFloat = 12
        static let size16: CGFloat = 16
        static let size14: CGFloat = 14
        static let size50: CGFloat = 50
        static let size0: CGFloat = 0
        static let size550: CGFloat = 550
        static let size18: CGFloat = 18
        static let size19: CGFloat = 19
    }

    //Констрейнты
    enum Offsets {
        static let constr15: CGFloat = 15
        static let constr020: CGFloat = 0.20
        static let constr1: CGFloat = 1
        static let constr037: CGFloat = 0.37
        static let constr006: CGFloat = 0.06
        static let constr0: CGFloat = 0
        static let constr033: CGFloat = 0.33
        static let constr0157: CGFloat = 0.157
        static let constr005: CGFloat = 0.05
        static let constr20: CGFloat = 20
        static let constrMinus15: CGFloat = -15
        static let constr0098: CGFloat = 0.098
        static let constr0045: CGFloat = 0.045
        static let constrMinus20: CGFloat = -20
        static let constr015: CGFloat = 0.15
        static let constr10: CGFloat = 10
        static let constr092: CGFloat = 0.92
        static let constr05: CGFloat = 0.5
        static let constr9: CGFloat = 9
        static let constr120: CGFloat = 120
        static let constr25: CGFloat = 25
        static let constr5: CGFloat = 5
        static let constr04: CGFloat = 0.4
    }

    //Иконки
    enum Icons {
        static let avatarButtonIcon: String = "logo"
        static let networkStatusLabelIcon: String = "iphone.homebutton"
        static let storiesButtonIcon: String = "camera"
        static let postButtonIcon: String = "square.and.pencil"
        static let photoButtonIcon: String = "photo"
        static let clipButtonIcon: String = "play.square"
        static let cityButtonIcon: String = "house"
        static let subscribersButtonIcon: String = "dot.radiowaves.up.forward"
        static let placeOfWorkButtonIcon: String = "briefcase"
        static let giftButtonIcon: String = "snowflake"
        static let detailedInfoButtonIcon: String = "exclamationmark.circle.fill"
        static let checkmarkIcon: String = "checkmark"
        static let friendsAvatars: [String] = ["friend 1", "friend 2", "friend 3", "friend 4", "friend 5", "friend 6", "friend 7", "friend 8", "friend 9", "friend 10"]
        static let forwardArrow: String = "chevron.right"
    }

    //Наименования
    enum Strings {
        static let myNameButtonText: String = "Maxim Bogdanov"
        static let networkStatusLabelText: String = "online "
        static let statusLabelText: String = "The universe inside us"
        static let editButtonText: String = "Edit"
        static let storiesButtonText: String = "Story"
        static let postButtonText: String = "Post"
        static let photoButtonText: String = "Photo"
        static let clipButtonText: String = "Clip"
        static let cityButtonText: String = "   City: Saint - Petersburg "
        static let subscribersButtonText: String = "   10324532 folowers"
        static let placeOfWorkButtonText: String = "   Add company"
        static let giftButtonText: String = "   Get a gift"
        static let detailedInfoButtonText: String = "   Additional info"
        static let friendsLabelText: String = "FRIENDS"
    }


    //Цвета
    enum Colors {
        static let whiteColor: UIColor = .white
        static let blueColor = UIColor(rgb: 0x70A8E9)
        static let grayColor = UIColor(rgb: 0x2C2D2E)
        static let lightGrayColor = UIColor(rgb: 0x707173)
        static let purpleColor = UIColor(rgb: 0x4D409A)
        static let backgroundColor = UIColor(rgb: 0x19191A)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

