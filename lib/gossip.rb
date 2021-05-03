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
      puts "Impossible de créer un fichier de nom \"./db/#{PREFIX}#{file_name}\"."
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

  private

  def self.check_file_name?(file_name)
    # Vérification simple du format du nom du fichier.
    # Si le nom est ok, ça renvoie TRUE, sinon ça renvoie FALSE.
    # On veut vérifier que le file_name n'est ni nil, ni une instance d'une autre classe que celle des String, ni une chaîne vide :
    !file_name.nil? && file_name.instance_of?(String) && !file_name.strip.empty?
  end
  
  #binding.pry
end
