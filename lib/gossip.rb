require 'csv'
#require 'pry'

class Gossip
  attr_reader :author # auteur (String) du potin
  attr_reader :content # contenu/texte (String) du potin
  
  PREFIX = 'LN_'.freeze # Ruby Freeze method basically make object constant or immutable
   
  def initialize(author, content)
    @author = author
    @content = content
  end

  def save(file_name)
    if Gossip.check_file_name?(file_name) # On vérifie le nom du fichier à créer via une méthode check_file_name? (cf. plus bas)
      CSV.open("./db/#{PREFIX}#{file_name}", "ab") do |csv_file| # le chemin relatif est donné par rapport au répertoire d'où est lancée l'application controller.rb
        csv_file << [@author, @content]
        # To encode a quote, use ". One double quote symbol in a field will be encoded as "", and the whole field will become """".
        # A comma is simply encapsulated using quotes, so , becomes ",".
        # A comma and quote needs to be encapsulated and quoted, so "," becomes """,""".
      end
    else
      puts "Impossible de créer/ajouter dans un fichier de nom \"./db/#{PREFIX}#{file_name}\"."
    end
  end
  
  def self.all(file_name)
    all_gossips = [] # création d'un Array d'instances de la classe Gossip, vide, qui s'appelle all_gossips
    if Gossip.check_file_name?(file_name) # On vérifie le nom du fichier à consulter via une méthode check_file_name? (cf. plus bas)
      CSV.open("./db/#{PREFIX}#{file_name}", "r") do |csv_file| # le chemin relatif est donné par rapport au répertoire d'où est lancée l'application controller.rb
        csv_file.each do |row| # pour chaque ligne de ton .csv
          all_gossips << Gossip.new(row[0], row[1])
          # rajoute au Array "all_gossips" le gossip (dont je n'ai pas sauvegardé la référence dans une variable "gossip_provisoire") créé avec les données de la ligne lue
        end
      end
    else
      puts "Impossible de consulter un fichier de nom \"./db/#{PREFIX}#{file_name}\"."
    end
    return all_gossips
  end

  def self.find_gossip_with_index(file_name, id)
    result = { "gossip" => nil, "index" => -1 }
    puts "id : #{id}"
    if Gossip.check_file_name?(file_name) # On vérifie le nom du fichier à consulter via une méthode check_file_name? (cf. plus bas)
      CSV.foreach("./db/#{PREFIX}#{file_name}").with_index do |row, row_number| # le chemin relatif est donné par rapport au répertoire d'où est lancée l'application controller.rb
        puts "row_number : #{row_number}"
        if (id != -1 && row_number + 1 == id) # on considère que l'utilsateur dénombre les potins dans la liste complète à partir du numéro/de l'id 1;
                                              # or, row_number "démarre" à 0!!!
          result = { "gossip" => Gossip.new(row[0], row[1]), "index" => row_number }
          puts "result : #{result}"
          break
        end
      end
    else
      puts "Impossible de consulter un fichier de nom \"./db/#{PREFIX}#{file_name}\"."
    end
    return result
  end

  def self.update(file_name, index, new_author, new_content)
    new_gossips_array = [] # création d'un Array d'instances de la classe Gossip, vide, qui s'appelle new_gossips_array
    puts "index : #{index}, new_author : #{new_author}, content : #{new_content}"
    if Gossip.check_file_name?(file_name) # On vérifie le nom du fichier à consulter via une méthode check_file_name? (cf. plus bas)
      CSV.foreach("./db/#{PREFIX}#{file_name}").with_index do |row, row_number| # le chemin relatif est donné par rapport au répertoire d'où est lancée l'application controller.rb
        print "row_number : #{row_number}"
        if row_number == index.to_i
          puts " => (#{new_author}, #{new_content})"
          new_gossips_array << Gossip.new(new_author, new_content)
          # rajoute au Array "new_gossips_array" un nouveau gossip de même index, mais avec un nouvel author et un nouveau content
        else
          puts " => (#{row[0]}, #{row[1]})"
          new_gossips_array << Gossip.new(row[0], row[1])
          # rajoute au Array "new_gossips_array" un nouveau gossip de même index, même author et même content
        end
      end
      Gossip.save_new_file(file_name, new_gossips_array)
    else
      puts "Impossible de consulter un fichier de nom \"./db/#{PREFIX}#{file_name}\"."
    end
  end

  private
  
  def self.save_new_file(file_name, new_gossips_array)
    if Gossip.check_file_name?(file_name) # On vérifie le nom du fichier à créer via une méthode check_file_name? (cf. plus bas)
      previous_version_number = 0
      while File.file?("./db/#{PREFIX}#{previous_version_number.to_s}_#{file_name}")
        previous_version_number += 1
      end
      File.rename("./db/#{PREFIX}#{file_name}", "./db/#{PREFIX}#{previous_version_number.to_s}_#{file_name}")
      CSV.open("./db/#{PREFIX}#{file_name}", "wb") do |csv_file| # le chemin relatif est donné par rapport au répertoire d'où est lancée l'application controller.rb
        new_gossips_array.length.times do |gossip_index|
          puts "gossip_index : #{gossip_index} => [#{new_gossips_array[gossip_index].author}, #{new_gossips_array[gossip_index].content}]"
          csv_file << [new_gossips_array[gossip_index].author, new_gossips_array[gossip_index].content]
          # To encode a quote, use ". One double quote symbol in a field will be encoded as "", and the whole field will become """".
          # A comma is simply encapsulated using quotes, so , becomes ",".
          # A comma and quote needs to be encapsulated and quoted, so "," becomes """,""".
        end
      end
    else
      puts "Impossible de créer un fichier de nom \"./db/#{PREFIX}#{file_name}\"."
    end
  end

  def self.check_file_name?(file_name)
    # Vérification simple du format du nom du fichier.
    # Si le nom est ok, ça renvoie TRUE, sinon ça renvoie FALSE.
    # On veut vérifier que le file_name n'est ni nil, ni une instance d'une autre classe que celle des String, ni une chaîne vide :
    !file_name.nil? && file_name.instance_of?(String) && !file_name.strip.empty?
  end
  
  #binding.pry
end
