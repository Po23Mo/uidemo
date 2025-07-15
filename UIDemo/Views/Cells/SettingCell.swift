import UIKit

enum SettingCellType {
    case `switch`
    case slider
    case stepper
    case textField
    case datePicker
    case picker
    case button
}

class SettingCell: UITableViewCell {
    
    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let switchControl = UISwitch()
    private let sliderControl = UISlider()
    private let stepperControl = UIStepper()
    private let textFieldControl = UITextField()
    private let datePickerControl = UIDatePicker()
    private let pickerControl = UIPickerView()
    private let buttonControl = UIButton(type: .system)
    private let valueLabel = UILabel()
    
    // MARK: - Properties
    private var currentType: SettingCellType = .switch
    private var valueChangeHandler: ((Any) -> Void)?
    private var pickerOptions: [String] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        // Title Label
        titleLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(titleLabel)
        
        // Value Label
        valueLabel.font = .systemFont(ofSize: 14)
        valueLabel.textColor = .systemGray
        valueLabel.textAlignment = .right
        contentView.addSubview(valueLabel)
        
        // Switch Control
        switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        contentView.addSubview(switchControl)
        
        // Slider Control
        sliderControl.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        contentView.addSubview(sliderControl)
        
        // Stepper Control
        stepperControl.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        contentView.addSubview(stepperControl)
        
        // Text Field Control
        textFieldControl.borderStyle = .roundedRect
        textFieldControl.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        contentView.addSubview(textFieldControl)
        
        // Date Picker Control
        datePickerControl.datePickerMode = .date
        datePickerControl.preferredDatePickerStyle = .compact
        datePickerControl.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        contentView.addSubview(datePickerControl)
        
        // Picker Control
        pickerControl.delegate = self
        pickerControl.dataSource = self
        contentView.addSubview(pickerControl)
        
        // Button Control
        buttonControl.setTitleColor(.systemBlue, for: .normal)
        buttonControl.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        contentView.addSubview(buttonControl)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        sliderControl.translatesAutoresizingMaskIntoConstraints = false
        stepperControl.translatesAutoresizingMaskIntoConstraints = false
        textFieldControl.translatesAutoresizingMaskIntoConstraints = false
        datePickerControl.translatesAutoresizingMaskIntoConstraints = false
        pickerControl.translatesAutoresizingMaskIntoConstraints = false
        buttonControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 100),
            
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: 80),
            
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            sliderControl.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            sliderControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sliderControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            stepperControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stepperControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            textFieldControl.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            textFieldControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textFieldControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textFieldControl.heightAnchor.constraint(equalToConstant: 30),
            
            datePickerControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            datePickerControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            pickerControl.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            pickerControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pickerControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pickerControl.heightAnchor.constraint(equalToConstant: 30),
            
            buttonControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(title: String, type: SettingCellType, value: Any? = nil, minValue: Float? = nil, maxValue: Float? = nil, options: [String]? = nil, handler: @escaping (Any) -> Void) {
        titleLabel.text = title
        currentType = type
        valueChangeHandler = handler
        pickerOptions = options ?? []
        
        // 隐藏所有控件
        hideAllControls()
        
        // 显示对应控件
        switch type {
        case .switch:
            switchControl.isHidden = false
            if let boolValue = value as? Bool {
                switchControl.isOn = boolValue
            }
            
        case .slider:
            sliderControl.isHidden = false
            if let floatValue = value as? Float {
                sliderControl.value = floatValue
            }
            if let min = minValue, let max = maxValue {
                sliderControl.minimumValue = min
                sliderControl.maximumValue = max
            }
            valueLabel.isHidden = false
            valueLabel.text = "\(Int(sliderControl.value))"
            
        case .stepper:
            stepperControl.isHidden = false
            if let intValue = value as? Int {
                stepperControl.value = Double(intValue)
            }
            if let min = minValue, let max = maxValue {
                stepperControl.minimumValue = Double(min)
                stepperControl.maximumValue = Double(max)
            }
            valueLabel.isHidden = false
            valueLabel.text = "\(Int(stepperControl.value))"
            
        case .textField:
            textFieldControl.isHidden = false
            if let stringValue = value as? String {
                textFieldControl.text = stringValue
            }
            
        case .datePicker:
            datePickerControl.isHidden = false
            if let dateValue = value as? Date {
                datePickerControl.date = dateValue
            }
            
        case .picker:
            pickerControl.isHidden = false
            valueLabel.isHidden = false
            if let stringValue = value as? String, let index = pickerOptions.firstIndex(of: stringValue) {
                pickerControl.selectRow(index, inComponent: 0, animated: false)
                valueLabel.text = stringValue
            }
            
        case .button:
            buttonControl.isHidden = false
            buttonControl.setTitle(title, for: .normal)
        }
    }
    
    private func hideAllControls() {
        switchControl.isHidden = true
        sliderControl.isHidden = true
        stepperControl.isHidden = true
        textFieldControl.isHidden = true
        datePickerControl.isHidden = true
        pickerControl.isHidden = true
        buttonControl.isHidden = true
        valueLabel.isHidden = true
    }
    
    // MARK: - Actions
    @objc private func switchValueChanged() {
        valueChangeHandler?(switchControl.isOn)
    }
    
    @objc private func sliderValueChanged() {
        valueLabel.text = "\(Int(sliderControl.value))"
        valueChangeHandler?(sliderControl.value)
    }
    
    @objc private func stepperValueChanged() {
        valueLabel.text = "\(Int(stepperControl.value))"
        valueChangeHandler?(Int(stepperControl.value))
    }
    
    @objc private func textFieldValueChanged() {
        valueChangeHandler?(textFieldControl.text ?? "")
    }
    
    @objc private func datePickerValueChanged() {
        valueChangeHandler?(datePickerControl.date)
    }
    
    @objc private func buttonTapped() {
        valueChangeHandler?(true)
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension SettingCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = pickerOptions[row]
        valueLabel.text = selectedValue
        valueChangeHandler?(selectedValue)
    }
} 