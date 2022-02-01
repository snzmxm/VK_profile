//
//  ViewController.swift
//  VK_profile
//
//  Created by SNZ on 02.02.2022.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: - Elements

    //Создание кнопки c фото
    private lazy var avatarButton: UIButton = {
        let avatarButton = UIButton()

        let image = UIImage(named: Icons.avatarButtonIcon)
        avatarButton.setImage(image, for: .normal)
        avatarButton.layer.masksToBounds = true
        avatarButton.layer.cornerRadius = Metric.avatarButtonCorners

        return avatarButton
    }()

    //Создание имени и фамилии
    private lazy var myNameLabel: UILabel = {
        let myNameLabel = UILabel()

        myNameLabel.text = Strings.myNameButtonText
        myNameLabel.font = .systemFont(ofSize: Metric.myNameLabelSize)
        myNameLabel.textColor = Colors.myNameColor
        myNameLabel.adjustsFontSizeToFitWidth = true

        return myNameLabel
    }()

    //Создание статуса
    private lazy var statusButton: UILabel = {
        let statusLabel = UILabel()

        statusLabel.text = Strings.statusLabelText
        statusLabel.font = .systemFont(ofSize: Metric.statusLabelSize)
        statusLabel.textColor = Colors.myNameColor
        statusLabel.adjustsFontSizeToFitWidth = true

        return statusLabel
    }()

    //Создание лейбла сетевого статуса
    private lazy var networkStatusLabel: UILabel = {
        let networkStatusLabel = UILabel()

        networkStatusLabel.text = Strings.networkStatusLabelText
        networkStatusLabel.font = .systemFont(ofSize: Metric.networkStatusLabelSize, weight: .medium)
        networkStatusLabel.textColor = Colors.networkColor
        networkStatusLabel.adjustsFontSizeToFitWidth = true

        //Добавление иконки телефона
        let imageAttachment = NSTextAttachment()
        let smallConfig = UIImage.SymbolConfiguration(pointSize: Metric.netWorkStatusLabelIconSize, weight: .medium, scale: .small)
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
        editButton.setTitleColor(Colors.editButtonTextColor, for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: Metric.editButtonTitleSize, weight: .medium)
        editButton.backgroundColor = Colors.editButtonBackColor
        editButton.titleLabel?.textAlignment = .center
        editButton.titleLabel?.adjustsFontSizeToFitWidth = true
        editButton.layer.cornerRadius = Metric.editButtonCorners

        return editButton
    }()

    //Создание разделителя
    private lazy var separatorViewOne: UIView = {
        let separatorViewOne = UIView()

        separatorViewOne.backgroundColor = Colors.separatorColor

        return separatorViewOne
    }()

    private lazy var separatorViewTwo: UIView = {
        let separatorViewTwo = UIView()

        separatorViewTwo.backgroundColor = Colors.separatorColor

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
    private lazy var checkmark = smallIcons(colorTitle: Colors.placeOfWorkButtonColor, icon: Icons.checkmarkIcon, iconSize: Metric.checkmarkButtonSize)
    private lazy var forwardArrow = smallIcons(colorTitle: Colors.forwardArrowColor, icon: Icons.forwardArrow, iconSize: Metric.forwardArrowSize)

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
                                                    colorTitle: Colors.cityButtonColor,
                                                    icon: Icons.cityButtonIcon,
                                                    iconSize: Metric.cityButtonIconSize)

    private lazy var subscribersButton = createInfoButtons(with: Strings.subscribersButtonText,
                                                           colorTitle: Colors.subscribersButtonColor,
                                                           icon: Icons.subscribersButtonIcon,
                                                           iconSize: Metric.subscribersButtonIconSize)

    private lazy var placeOfWorkButton = createInfoButtons(with: Strings.placeOfWorkButtonText,
                                                           colorTitle: Colors.placeOfWorkButtonColor,
                                                           icon: Icons.placeOfWorkButtonIcon,
                                                           iconSize: Metric.placeOfWorkButtonIconSize)

    private lazy var giftButton = createInfoButtons(with: Strings.giftButtonText,
                                                    colorTitle: Colors.giftButtonColor,
                                                    icon: Icons.giftButtonIcon,
                                                    iconSize: Metric.giftButtonIconSize)

    private lazy var detailedInfoButton = createInfoButtons(with: Strings.detailedInfoButtonText,
                                                            colorTitle: Colors.detailedInfoButtonColor,
                                                            icon: Icons.detailedInfoButtonIcon,
                                                            iconSize: Metric.detailedInfoButtonIconSize)

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
                                          constant: 5).isActive = true
        avatarButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                           constant: Offsets.avatarButtonLeftOffset).isActive = true
        avatarButton.widthAnchor.constraint(equalTo: view.widthAnchor,
                                            multiplier: Offsets.avatarButtonWidth).isActive = true
        avatarButton.widthAnchor.constraint(equalTo: avatarButton.heightAnchor,
                                            multiplier: Offsets.avatarButtonRatio).isActive = true


        myNameLabel.translatesAutoresizingMaskIntoConstraints = false
        myNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                         constant: Offsets.myNameLabelTopOffset).isActive = true
        myNameLabel.leftAnchor.constraint(equalTo: avatarButton.rightAnchor,
                                          constant: Offsets.myNameLabelLeftOffset).isActive = true
        myNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor,
                                           multiplier: Offsets.myNameLabelWidthOffset).isActive = true
        myNameLabel.heightAnchor.constraint(equalTo: view.widthAnchor,
                                            multiplier: Offsets.myNameLabelHeightOffset).isActive = true


        statusButton.translatesAutoresizingMaskIntoConstraints = false
        statusButton.topAnchor.constraint(equalTo: myNameLabel.bottomAnchor,
                                          constant: Offsets.statusButtonTopOffset).isActive = true
        statusButton.leftAnchor.constraint(equalTo: avatarButton.rightAnchor,
                                           constant: Offsets.statusButtonLeftOffset).isActive = true
        statusButton.widthAnchor.constraint(equalTo: view.widthAnchor,
                                            multiplier: Offsets.statusButtonWidthOffset).isActive = true
        statusButton.heightAnchor.constraint(equalTo: view.widthAnchor,
                                             multiplier: Offsets.statusButtonHeightOffset).isActive = true


        networkStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        networkStatusLabel.topAnchor.constraint(equalTo: statusButton.bottomAnchor,
                                                constant: Offsets.networkStatusLabelTopOffset).isActive = true
        networkStatusLabel.leftAnchor.constraint(equalTo: avatarButton.rightAnchor,
                                                 constant: Offsets.networkStatusLabelLeftOffset).isActive = true
        networkStatusLabel.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                  multiplier: Offsets.networkStatusLabelWidthOffset).isActive = true
        networkStatusLabel.heightAnchor.constraint(equalTo: view.widthAnchor,
                                                   multiplier: Offsets.networkStatusLabelHeightOffset).isActive = true


        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.topAnchor.constraint(equalTo: networkStatusLabel.bottomAnchor,
                                        constant: Offsets.editButtonTopOffset).isActive = true
        editButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                         constant: Offsets.editButtonLeftOffset).isActive = true
        editButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                          constant: Offsets.editButtonRightOffset).isActive = true
        editButton.heightAnchor.constraint(equalTo: view.widthAnchor,
                                           multiplier: Offsets.editButtonHeightOffset).isActive = true
        editButton.titleLabel?.heightAnchor.constraint(equalTo: view.widthAnchor,
                                                       multiplier: Offsets.editButtonLabelOffset).isActive = true


        addContentStackView.translatesAutoresizingMaskIntoConstraints = false
        addContentStackView.topAnchor.constraint(equalTo: editButton.bottomAnchor,
                                                 constant: Offsets.contentStackViewTopOffset).isActive = true
        addContentStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                  constant: Offsets.contentStackViewLeftOffset).isActive = true
        addContentStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                   constant: Offsets.contentStackViewRightOffset).isActive = true
        addContentStackView.heightAnchor.constraint(equalTo: view.widthAnchor,
                                                    multiplier: Offsets.contentStackViewHeightOffset).isActive = true


        separatorViewOne.translatesAutoresizingMaskIntoConstraints = false
        separatorViewOne.topAnchor.constraint(equalTo: addContentStackView.bottomAnchor,
                                              constant: Offsets.separatorViewTopOffset).isActive = true
        separatorViewOne.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                               constant: Offsets.separatorViewLeftOffset).isActive = true
        separatorViewOne.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                constant: Offsets.separatorViewRightOffset).isActive = true
        separatorViewOne.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                multiplier: Offsets.separatorViewWidthOffset).isActive = true
        separatorViewOne.heightAnchor.constraint(equalToConstant: Offsets.separatorViewHeightOffset).isActive = true


        separatorViewTwo.translatesAutoresizingMaskIntoConstraints = false
        separatorViewTwo.topAnchor.constraint(equalTo: infoButtonsStackView.bottomAnchor,
                                              constant: Offsets.separatorViewTwoTopOffset).isActive = true
        separatorViewTwo.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                               constant: Offsets.separatorViewLeftOffset).isActive = true
        separatorViewTwo.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                constant: Offsets.separatorViewRightOffset).isActive = true
        separatorViewTwo.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                multiplier: Offsets.separatorViewWidthOffset).isActive = true
        separatorViewTwo.heightAnchor.constraint(equalToConstant: Offsets.separatorViewHeightOffset).isActive = true


        friendsButton.translatesAutoresizingMaskIntoConstraints = false
        friendsButton.topAnchor.constraint(equalTo: separatorViewTwo.bottomAnchor,
                                           constant: Offsets.friendsButtonTopOffset).isActive = true
        friendsButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                            constant: Offsets.friendsButtonLeftOffset).isActive = true
        friendsButton.widthAnchor.constraint(equalTo: view.widthAnchor,
                                             multiplier: Offsets.myNameLabelWidthOffset).isActive = true
        friendsButton.heightAnchor.constraint(equalTo: view.widthAnchor,
                                              multiplier: Offsets.myNameLabelHeightOffset).isActive = true


        infoButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        infoButtonsStackView.topAnchor.constraint(equalTo: separatorViewOne.bottomAnchor,
                                                  constant: Offsets.infoButtonsStackViewTopOffset).isActive = true
        infoButtonsStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                   constant: Offsets.infoButtonsStackViewLeftOffset).isActive = true
        infoButtonsStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                    constant: Offsets.infoButtonsStackViewRightOffset).isActive = true
        infoButtonsStackView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                    multiplier: Offsets.infoButtonsStackViewWidthOffset).isActive = true
        infoButtonsStackView.heightAnchor.constraint(equalTo: view.widthAnchor,
                                                     multiplier: Offsets.infoButtonsStackViewHeightOffset).isActive = true



        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                       constant: Offsets.checkmarkTopOffset).isActive = true
        checkmark.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                        constant: Offsets.checkmarkLeftOffset).isActive = true
        checkmark.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                         constant: Offsets.checkmarkRightOffset).isActive = true
        checkmark.heightAnchor.constraint(equalTo: view.widthAnchor,
                                          multiplier: Offsets.editButtonHeightOffset).isActive = true

        forwardArrow.translatesAutoresizingMaskIntoConstraints = false
        forwardArrow.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                          constant: Offsets.forwardArrowTopOffset).isActive = true
        forwardArrow.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                           constant: Offsets.forwardArrowLeftOffset).isActive = true
        forwardArrow.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                            constant: Offsets.forwardArrowRightOffset).isActive = true
        forwardArrow.heightAnchor.constraint(equalTo: view.widthAnchor,
                                             multiplier: Offsets.editButtonHeightOffset).isActive = true

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
        container.font = UIFont.systemFont(ofSize: Metric.contentButtonsTitleSize, weight: .semibold)
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(title, attributes: container)
        configuration.image = UIImage(systemName: icon)
        configuration.imagePlacement = .top
        configuration.imagePadding = 15
        configuration.baseForegroundColor = Colors.contentButtonsColor
        let button = UIButton(configuration: configuration, primaryAction: nil)

        return button
    }

    //Создание StackView с друзьями(Тестил на Iphone 13 pro) Пока что не разобрался, как привязать констрейнтами кнопки сделал через viewDidLayoutSubviews
    private var collectionView: UICollectionView?

    private func collectionViewFriends() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: Metric.imageSize, height: Metric.imageSize)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(CircleCollectionViewCell.self, forCellWithReuseIdentifier: CircleCollectionViewCell.identifier)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor(rgb: 0x19191A)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let myCollection = collectionView else{
            return
        }
        view.addSubview(myCollection)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = CGRect(x: 0, y: 550, width: view.frame.size.width, height: 50).integral
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
        static let avatarButtonCorners: CGFloat = 40
        static let myNameLabelSize: CGFloat = 20
        static let statusLabelSize: CGFloat = 15
        static let networkStatusLabelSize: CGFloat = 13
        static let netWorkStatusLabelIconSize: CGFloat = 13
        static let editButtonTitleSize: CGFloat = 15
        static let editButtonCorners: CGFloat = 10
        static let cityButtonIconSize: CGFloat = 12
        static let subscribersButtonIconSize: CGFloat = 16
        static let placeOfWorkButtonIconSize: CGFloat = 13
        static let giftButtonIconSize: CGFloat = 16
        static let detailedInfoButtonIconSize: CGFloat = 15
        static let infoButtonsTitleSize: CGFloat = 16
        static let contentButtonsTitleSize: CGFloat = 14
        static let friendsButtonsSize: CGFloat = 10
        static let checkmarkButtonSize: CGFloat = 10
        static let imageSize: CGFloat = 50
        static let forwardArrowSize: CGFloat = 15
    }

    //Констрейнты
    enum Offsets {
        static let avatarButtonTopOffset: CGFloat = 28
        static let avatarButtonLeftOffset: CGFloat = 15
        static let avatarButtonWidth: CGFloat = 0.20
        static let avatarButtonRatio: CGFloat = 1
        static let myNameLabelTopOffset: CGFloat = 15
        static let myNameLabelLeftOffset: CGFloat = 15
        static let myNameLabelWidthOffset: CGFloat = 0.37
        static let myNameLabelHeightOffset: CGFloat = 0.06
        static let statusButtonTopOffset: CGFloat = 0
        static let statusButtonLeftOffset: CGFloat = 15
        static let statusButtonWidthOffset: CGFloat = 0.33
        static let statusButtonHeightOffset: CGFloat = 0.06
        static let networkStatusLabelTopOffset: CGFloat = 0
        static let networkStatusLabelLeftOffset: CGFloat = 15
        static let networkStatusLabelWidthOffset: CGFloat = 0.157
        static let networkStatusLabelHeightOffset: CGFloat = 0.05
        static let editButtonTopOffset: CGFloat = 20
        static let editButtonLeftOffset: CGFloat = 15
        static let editButtonRightOffset: CGFloat = -15
        static let editButtonHeightOffset: CGFloat = 0.098
        static let editButtonLabelOffset: CGFloat = 0.045
        static let contentStackViewTopOffset: CGFloat = 15
        static let contentStackViewLeftOffset: CGFloat = 20
        static let contentStackViewRightOffset: CGFloat = -20
        static let contentStackViewHeightOffset: CGFloat = 0.15
        static let separatorViewTopOffset: CGFloat = 10
        static let separatorViewLeftOffset: CGFloat = 15
        static let separatorViewRightOffset: CGFloat = 15
        static let separatorViewWidthOffset: CGFloat = 0.92
        static let separatorViewHeightOffset: CGFloat = 0.5
        static let separatorViewTwoTopOffset: CGFloat = 15
        static let friendsButtonTopOffset: CGFloat = 10
        static let friendsButtonLeftOffset: CGFloat = -20
        static let checkmarkTopOffset: CGFloat = 9
        static let checkmarkLeftOffset: CGFloat = 120
        static let checkmarkRightOffset: CGFloat = 25
        static let forwardArrowTopOffset: CGFloat = 330
        static let forwardArrowLeftOffset: CGFloat = 340
        static let forwardArrowRightOffset: CGFloat = 18
        static let infoButtonsStackViewTopOffset: CGFloat = 15
        static let infoButtonsStackViewLeftOffset: CGFloat = 15
        static let infoButtonsStackViewRightOffset: CGFloat = 15
        static let infoButtonsStackViewWidthOffset: CGFloat = 0.92
        static let infoButtonsStackViewHeightOffset: CGFloat = 0.4
    }

    //Иконки
    enum Icons {
        static let avatarButtonIcon: String = "logo.png"
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
        static let myNameColor: UIColor = .white
        static let contentButtonsColor = UIColor(rgb: 0x70A8E9)
        static let editButtonTextColor: UIColor = .white
        static let editButtonBackColor = UIColor(rgb: 0x2C2D2E)
        static let forwardArrowColor = UIColor(rgb: 0x2C2D2E)
        static let cityButtonColor = UIColor(rgb: 0x707173)
        static let networkColor = UIColor(rgb: 0x707173)
        static let separatorColor: UIColor = .darkGray
        static let statusColor: UIColor = .white
        static let subscribersButtonColor = UIColor(rgb: 0x707173)
        static let placeOfWorkButtonColor = UIColor(rgb: 0x70A8E9)
        static let giftButtonColor = UIColor(rgb: 0x4D409A)
        static let detailedInfoButtonColor: UIColor = .white
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

