# Clear existing data (order matters due to foreign keys)
MaintenanceRecord.delete_all
Equipment.delete_all
Category.delete_all

puts "Seeding categories..."

computing    = Category.create!(name: "Computing")
optics       = Category.create!(name: "Optics")
networking   = Category.create!(name: "Networking")
electronics  = Category.create!(name: "Electronics")

puts "Seeding equipment..."

laptop1 = Equipment.create!(
  name: "Dell Laptop Pro",
  serial_number: "LAP-001",
  status: "available",
  category: computing
)

laptop2 = Equipment.create!(
  name: "MacBook Air",
  serial_number: "LAP-002",
  status: "in_use",
  category: computing
)

microscope1 = Equipment.create!(
  name: "Binocular Microscope",
  serial_number: "MIC-001",
  status: "available",
  category: optics
)

microscope2 = Equipment.create!(
  name: "Digital Microscope",
  serial_number: "MIC-042",
  status: "maintenance",
  category: optics
)

router1 = Equipment.create!(
  name: "Cisco Router",
  serial_number: "RTR-001",
  status: "available",
  category: networking
)

router2 = Equipment.create!(
  name: "TP-Link Switch",
  serial_number: "SWT-001",
  status: "in_use",
  category: networking
)

arduino1 = Equipment.create!(
  name: "Arduino Mega Kit",
  serial_number: "ARD-001",
  status: "available",
  category: electronics
)

arduino2 = Equipment.create!(
  name: "Raspberry Pi 4",
  serial_number: "ARD-999",
  status: "maintenance",
  category: electronics
)

puts "Seeding maintenance records..."

MaintenanceRecord.create!(
  description: "Replaced thermal paste and cleaned cooling fan.",
  performed_at: 3.weeks.ago,
  equipment: laptop1
)

MaintenanceRecord.create!(
  description: "Battery replacement and keyboard cleaning.",
  performed_at: 1.week.ago,
  equipment: laptop2
)

MaintenanceRecord.create!(
  description: "Cleaned lenses and recalibrated focus mechanism.",
  performed_at: 2.weeks.ago,
  equipment: microscope2
)

MaintenanceRecord.create!(
  description: "Full lens cleaning and calibration check.",
  performed_at: 5.days.ago,
  equipment: microscope2
)

MaintenanceRecord.create!(
  description: "Firmware update and port inspection.",
  performed_at: 10.days.ago,
  equipment: router1
)

puts ""
puts "Seed complete!"
puts "  Categories: #{Category.count}"
puts "  Equipment:  #{Equipment.count}"
puts "  Maintenance Records: #{MaintenanceRecord.count}"
