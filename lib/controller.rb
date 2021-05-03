require 'gossip'

class ApplicationController < Sinatra::Base
  get '/' do
    erb :index
  end
  get '/gossips/all/' do
    erb :all_gossips, locals: {gossips: Gossip.all("gossip.csv")}
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
end
