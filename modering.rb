require 'rubygems'
#require 'sinatra'
#require './datalist.rb'

def rock

    {

      'a'=> {"the cabs" => 8, "People in the box" => 7, "androp" => 4, "宇宙コンビニ" => 9, "凛として時雨" => 3, "the HIATUS" => 6},
      
      'b' => {"androp" => 10, "凛として時雨" => 4},
      
      'c' => {"the cabs" => 4, "People in the box" => 3, "androp" => 8, "凛として時雨" => 2, "the HIATUS" => 9},
      
      'd' => {"the cabs" => 10, "People in the box" => 8, "androp" => 9, "宇宙コンビニ" => 10, "凛として時雨" => 9, "the HIATUS" => 5},
      
      'e' => {"People in the box" => 4, "androp" => 8, "宇宙コンビニ" => 5},
      
      'usr'=> {"the cabs" => @data1, "People in the box" => @data2, "androp" => @data3, "宇宙コンビニ" => @data4, "凛として時雨" => @data5, "the HIATUS" => @data6},
    
    }

end

def metal

      {
      
      'a'=> {"Destrage" => 8, "Arch Enemy" => 7, "Dragonforce" => 4, "Periphery" => 9, "SEX MACHINEGUNS" => 3, "METALICA" => 6},
      
      'b' => {"Dragonforce" => 10, "METALICA" => 4},
      
      'c' => {"Destrage" => 4, "Arch Enemy" => 3, "Dragonforce" => 8, "SEX MACHINEGUNS" => 2, "METALICA" => 9},
      
      'd' => {"Destrage" => 10, "Arch Enemy" => 4, "Dragonforce" => 9, "Periphery" => 10, "SEX MACHINEGUNS" => 6, "METALICA" => 2},
      
      'e' => {"Destrage" => 7, "Periphery" => 8},
      
      'usr'=> {"Destrage" => @data1, "Arch Enemy" => @data2, "Dragonforce" => @data3, "Periphery" => @data4, "SEX MACHINEGUNS" => @data5, "METALICA" => @data6},

      }
end




def shared_items_a(prefs, person1, person2)
  prefs[person1].keys & prefs[person2].keys
end

def sim_pearson(prefs, person1, person2)
  shared_items_a = shared_items_a(prefs, person1, person2)
  
  n = shared_items_a.size
  return 0 if n == 0

  sum1 = shared_items_a.inject(0) {|result,si|
    result + prefs[person1][si]
  } 
  sum2 = shared_items_a.inject(0) {|result,si|
    result + prefs[person2][si]
  } 
  sum1_sq = shared_items_a.inject(0) {|result,si|
    result + prefs[person1][si]**2
  }
  sum2_sq = shared_items_a.inject(0) {|result,si|
    result + prefs[person2][si]**2
  } 
  sum_products = shared_items_a.inject(0) {|result,si|
    result + prefs[person1][si]*prefs[person2][si]
  }
  num = sum_products - (sum1*sum2/n)
  den = Math.sqrt((sum1_sq - sum1**2/n)*(sum2_sq - sum2**2/n))
  return 0 if den == 0
  return num/den
end


def top_matches(prefs, person, n=6, similarity=:sim_pearson)
  scores = Array.new
  prefs.each do |key,value|
    if key != person
      scores << [__send__(similarity,prefs,person,key),key]
    end
  end
  scores.sort.reverse[0,n].reject {|x, y| x <= 0}
end

def get_recommendations(prefs, person, similarity=:sim_pearson)
  totals_h = Hash.new(0)
  sim_sums_h = Hash.new(0)

  prefs.each do |other,val|
    next if other == person
    sim = __send__(similarity,prefs,person,other)
    next if sim <= 0
    prefs[other].each do |item, val|
      if !prefs[person].keys.include?(item) || prefs[person][item] == 0
        totals_h[item] += prefs[other][item]*sim
        sim_sums_h[item] += sim
      end
    end
  end

  rankings = Array.new
  totals_h.each do |item,total|
    rankings << [total/sim_sums_h[item], item]
  end
  rankings.sort.reverse.reject {|x,y| x == 0}

end

puts 'どんなジャンルのアーティストをお探しですか？'
genre = gets.chomp

puts

puts 'アーティストの評価を入力してください（知らないアーティストは評価しないでください'

if genre == 'rock' then
puts 'the cabs'
@data1 = gets.to_i
puts 'People in the box'
@data2 = gets.to_i
puts 'androp'
@data3 = gets.to_i
puts '宇宙コンビニ'
@data4 = gets.to_i
puts '凛として時雨'
@data5 = gets.to_i
puts 'the HIATUS'
@data6 = gets.to_i

elsif genre == 'metal' then
puts 'Destrage'
@data1 = gets.to_i
puts 'Arch Enemy'
@data2 = gets.to_i
puts 'Dragonforce'
@data3 = gets.to_i
puts 'Periphery'
@data4 = gets.to_i
puts 'SEX MACHINEGUNS'
@data5 = gets.to_i
puts 'METALICA'
@data6 = gets.to_i

else
  exit
end


puts
puts
puts '【あなたと好みが似ているユーザー』'
puts
puts top_matches(rock, 'usr') if genre == 'rock'
puts top_matches(metal, 'usr') if genre == 'metal'
puts
puts '【あなたにオススメのアーティスト】'
puts
puts get_recommendations(rock, 'usr') if genre == 'rock'
puts get_recommendations(metal, 'usr') if genre == 'metal'
