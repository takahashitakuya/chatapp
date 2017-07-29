API_KEY = ENV['API_KEY']
API_URL = 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue'
class ChatsController < ApplicationController
  def index
    
    @chats = Chat.order("created_at DESC")
    @new_message = Chat.new
    
    
    
  end
  
  def create
    @chat = Chat.new(chat_params)
   
    @chat.save
     @talk = get_talk(@chat.message)
    redirect_to chats_path
  end
  
  def destroy
    Chat.destroy_all
    redirect_to chats_path
  end
  
  private
  
  def chat_params
    params.require(:chat).permit(:message,:user)
  end
  
  
  def get_talk(text)
    body = make_body(text) 
    
    apikey = '336e724a4e706973704e4b4f654a7170566549554355516343784252344654322e78767850734568512e39'
    uri = URI.parse("https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue")    
    uri.query = 'APIKEY=' + apikey
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri, {'Content-Type' => 'application/json'})
    req.body = body.to_json
    res = nil
    http.start do |h|
      resp = h.request(req)
      res = resp.body
    end
    data = JSON.parse(res)   
    chat = Chat.new(message:data["utt"],user:"bot")
    chat.save
  end
  
  def make_body(text)
    body = {
      utt: text
    }
    body[:context] = @context if @context
    body[:mode] = @mode if @mode
    body
  end  
end
