class LinebotController < ApplicationController

  require 'line/bot'
  protect_from_forgery except: [:callback]
  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request'
      end
    end
    events=client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          seed1=select_word
          seed2=select_word
          while seed1==seed2
            seed2 = select_word
          end
          message = [{
              type: 'text',
              text: "What is keyword?"
                     },{
              type: 'text',
              text: "#{seed1} x #{seed2} !!"
                     }]
          client.reply_message(event['replyToken'], message)
          end
        end
    }
      head :ok
    end
    private
      def client
        @client ||= Line::Bot::Client.new { |config|
          config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
          config.channel_token=ENV["LINE_CHANNEL_TOKEN"]
        }
      end
      def select_word
        seeds = ["idea1","idea2","idea3","idea4"]
        seeds.sample

      end


end
