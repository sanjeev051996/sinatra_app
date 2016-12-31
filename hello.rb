
# encoding: utf-8
#require 'rubygems'
require 'sinatra'
require 'plivo'
include Plivo

# This file will be played when a caller presses 2.
$PLIVO_SONG = "https://s3.amazonaws.com/plivocloud/music.mp3"

# This is the message that Plivo reads when the caller dials in
$IVR_MESSAGE1 = "Welcome to the Plivo IVR Demo App. Press 1 to listen to a pre recorded text in different languages. Press 2 to listen to a song."

$IVR_MESSAGE2 = "Press 1 for English. Press 2 for French. Press 3 for Russian"
# This is the message that Plivo reads when the caller does nothing at all
$NO_INPUT_MESSAGE = "Sorry, I didn't catch that. Please hangup and try again later."

# This is the message that Plivo reads when the caller inputs a wrong number.
$WRONG_INPUT_MESSAGE = "Sorry, it's wrong input."

get '/response/ivr' do
    r = Response.new()

    getdigits_action_url = "https://stark-bayou-68090.herokuapp.com/response/ivr"
    params = {
        'action' => getdigits_action_url,
        'method' => 'POST',
        'timeout' => '7',
        'numDigits' => '1',
        'retries' => '1'
    }
    getDigits = r.GetDigits(params)

    getDigits.addSpeak($IVR_MESSAGE1)
    r.addSpeak($NO_INPUT_MESSAGE)

    puts r.to_xml()
    content_type 'text/xml'
    return r.to_s()

end

post '/response/ivr' do
    digit = params[:Digits]

    r = Response.new()

    if (digit == "1")
        getdigits_action_url = "https://stark-bayou-68090.herokuapp.com/response/tree"
        params = {
            'action' => getdigits_action_url,
            'method' => 'GET',
            'timeout' => '7',
            'numDigits' => '1',
            'retries' => '1'
        }
        getDigits = r.GetDigits(params)

        getDigits.addSpeak($IVR_MESSAGE2)
        r.addSpeak($NO_INPUT_MESSAGE)

    elsif (digit == "2")
        r.addPlay($PLIVO_SONG)
    else
        r.addSpeak($WRONG_INPUT_MESSAGE)
    end

    puts r.to_xml()
    content_type 'text/xml'
    return r.to_s()

end

get '/response/tree' do
    digit = params[:Digits]

    r = Response.new()

    if (digit == "1")
        body = "This message is being read out in English"
        params = {
            'language'=> "en-GB"
        }

        r.addSpeak(body,params)
    elsif (digit == "2")
        body = "Ce message est lu en français"
        params = {
            'language'=> "fr-FR"
        }

        r.addSpeak(body,params)
    elsif (digit == "3")
        body = "Это сообщение было прочитано в России"
        params = {
            'language'=> "ru-RU"
        }

        r.addSpeak(body,params)
    else
        r.addSpeak($WRONG_INPUT_MESSAGE)
    end

    puts r.to_xml()
    content_type 'text/xml'
    return r.to_s()

end
