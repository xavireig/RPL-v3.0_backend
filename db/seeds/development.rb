(1..4).each do |t|
  cs = CrestShape.new(
    name: "Shape #{t}",
    svg: File.open(Rails.root.join('db', 'seeds', 'svgs', "shape#{t}.svg"), 'r')
  )
  sleep 2
  cs.save!
  (1..5).each do |c|
    cp = CrestPattern.create!(
      name: "Pattern #{t}#{c}",
      crest_shape: cs,
      svg: File.open(
          Rails.root.join('db', 'seeds', 'svgs', "pattern#{t}#{c}.svg"),
          'r'
      )
    )
    sleep 2
    cp.save!
  end
  sleep 2
end
