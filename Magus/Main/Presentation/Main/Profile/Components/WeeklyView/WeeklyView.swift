//
//  WeeklyView.swift
//  Magus
//
//  Created by Jomz on 7/27/23.
//

import UIKit

class WeeklyView: ReusableXibView {
    
    @IBOutlet var weeklyDateStackView: UIStackView!
    
    @IBOutlet var weeklyInfoStackView: UIStackView!
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func configure(_ weeklyData: [WeeklyData]) {
        let frame: CGRect = .init(origin: .zero, size: .init(width: self.frame.width, height: 57))
        for data in weeklyData {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .center
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .center
            let dayLbl = UILabel()
            dayLbl.textAlignment = .center
            dayLbl.font = .Montserrat.bold15
            dayLbl.text = data.day
            let dateLbl = UILabel()
            dateLbl.numberOfLines = 2
            dateLbl.textAlignment = .center
            dateLbl.font = .Montserrat.body3
            dateLbl.backgroundColor = .Background.primary
            let dayAttrib = NSAttributedString(string: data.day + "\n", attributes: [.font: UIFont.Montserrat.bold15])
            let dateAttrib = NSAttributedString(string: data.dayString, attributes: [.font: UIFont.Montserrat.body3])
            let attributedString = NSMutableAttributedString(attributedString: dayAttrib)
            attributedString.append(dateAttrib)
            
            dateLbl.attributedText = attributedString
            
            stackView.addArrangedSubview(dateLbl)
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 56).isActive = true
            view.addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
                stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ])
            weeklyDateStackView.addArrangedSubview(view)
            
            guard let mood = data.mood else {
                return
            }
            
            let weeklyView = WeeklyDayDetailView(frame: frame)
            weeklyView.configure(url: URL(string: mood.image ?? ""), mood: mood.name, desc: mood.description)
            weeklyInfoStackView.addArrangedSubview(weeklyView)
        }
        
        self.addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: weeklyDateStackView.topAnchor, constant: 5),
            lineView.bottomAnchor.constraint(equalTo: weeklyDateStackView.bottomAnchor, constant: -5),
            lineView.centerXAnchor.constraint(equalTo: weeklyDateStackView.centerXAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 1.5),
        ])
        self.sendSubviewToBack(lineView)
    }
    
}
