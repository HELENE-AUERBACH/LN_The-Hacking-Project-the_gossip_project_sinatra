require 'gossip'

class ApplicationController < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/gossips/new/' do
    erb :new_gossip
  end

  post '/gossips/new/' do
    puts "Ce programme sauvegarde un potin en base (ce message est seulement affiché dans le terminal)."
    puts "Salut, je suis dans le serveur"
    puts "Ceci est le contenu du hash params : #{params}"
    puts "Trop bien ! Et ceci est ce que l'utilisateur a passé dans le champ gossip_author : #{params["gossip_author"]}"
    puts "De la bombe, et du coup ça, ça doit être ce que l'utilisateur a passé dans le champ gossip_content : #{params["gossip_content"]}"
    puts "Ça déchire sa mémé, bon allez je m'en vais du serveur, ciao les BGs !"
    Gossip.new(params["gossip_author"], params["gossip_content"]).save("gossip.csv")
    redirect '/' # maintenant, redirige le user vers cette route
  end

  get '/gossips/all/' do
    erb :all_gossips, locals: {gossips: Gossip.all("gossip.csv")}
  end

  get '/gossips/:id/' do
    if !params['id'].nil? && !params['id'].strip.empty? && params['id'] != "-1" && params['id'].to_i > 0
      # on considère que l'utilisateur compte les potins à partir du numéro 1
      puts "Voici le numéro du potin que tu veux afficher : #{params['id']}!"
      erb :show, locals: {gossip_hash: Gossip.find_gossip_with_index("gossip.csv", params['id'].to_i), id: params['id']}
    else
      puts "Tu n'as sélectionné aucun numéro de potin."
    end
  end

  get '/gossips/:id/edit/' do
    if !params['id'].nil? && !params['id'].strip.empty? && params['id'] != "-1" && params['id'].to_i > 0
      puts "Voici le numéro du potin que tu veux éditer : #{params['id']}!"
      erb :edit, locals: {gossip_hash: Gossip.find_gossip_with_index("gossip.csv", params['id'].to_i), id: params['id']}
    else
      puts "Tu n'as sélectionné aucun numéro de potin."
    end
  end

  post '/gossips/:id/edit/' do
    puts "Ce programme sauvegarde en base un potin mis à jour."
    puts "Ceci est le contenu du hash params : #{params}"
    Gossip.update("gossip.csv", params["index"], params["gossip_author"], params["gossip_content"])
    redirect '/' # maintenant, redirige le user vers cette route
  end
end
