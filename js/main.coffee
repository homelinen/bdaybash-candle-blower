# Main Script File

imgDir = "img"
CandleBlower = ->

    # Sprites
    player = null
    candle = null
    wind = null

    # Candle Vars
    candles = []
    candleX = []
    litCandles = []

    # Player Vars
    curPos = 1
    pressed = false
    drawWind = false

    # Game Vars
    timeout = false
    stop = false
    canDrawText = false

    @setup = ->
        screenThirds = (jaws.width - 100) / 3

        for i in [0..2]
            candleX[i] = screenThirds * (i + 1)

        for i in [0..2]
            candles[i] = new jaws.Sprite({
                image: imgDir + "/candle-lit.png",
                x: 0,
                y: 300
            })
            candles[i].x = candleX[i] - candles[i].image.width / 2

            litCandles[i] = true
        
        player = new jaws.Sprite({
            image: imgDir + "/face.png",
            x: candleX[curPos],
            y: 5
        })

        player.x = player.x - (player.image.width / 2)

        wind = new jaws.Sprite({
            image: imgDir + "/breath.png",
            x: candleX[curPos],
            y: 10 + (player.image.height / 1.3)
        })

        setTimeout(->
            timeout = true
            return
        , 5000)

        # Start instructions
        canDrawText = true
        return

    @draw = ->
        jaws.clear()
        player.draw()
        for candle in candles
            candle.draw()

        if drawWind
            console.log "Blowing"
            wind.x = candleX[curPos] - wind.image.width / 2
            wind.draw()

        if canDrawText 
            drawText("BLOW!")
        return

    @update = ->
        if timeout && !stop
            for lit in litCandles
                if lit
                    oneLeft = lit
            
            if !oneLeft
                parent.winstate = true
                console.log "WINNNER!"
            else
                console.log "LOSER"
                parent.winstate = false
            stop = true

        if !(stop)
            if !pressed
                if (jaws.pressed("left"))
                    player.x = candleX[updatePos(-1)] - (player.image.width / 2)

                    pressed = true
                if (jaws.pressed("right"))
                    player.x = candleX[updatePos(1)] - (player.image.width / 2)
                    pressed = true
                if (jaws.pressed("space"))
                    console.log "Blow"
                    blow()
                    blowOutCandle(curPos)
                    pressed = true

                if pressed
                    setTimeout(->
                        pressed = false
                        return
                    , 200)

    updatePos = (x) ->
        if curPos + x < candleX.length  && curPos + x >= 0
            curPos += x
        curPos

    # Create a gust of wind
    blow = ->
        drawWind = true

        setTimeout(->
            drawWind = false
            return
        , 200)

    blowOutCandle = (pos) ->
        if litCandles[pos]
            candles[pos].setImage imgDir + "/candle-unlit.png"
            litCandles[pos] = false
            setTimeout(->
                litCandles[pos] = true
                candles[pos].setImage imgDir + "/candle-lit.png"
            , 3500)



    drawText = (text) ->

        # Font setup
        jaws.context.font = "3em sans-serif"
        jaws.context.lineWidth = 1
        jaws.context.textAlign = "center"

        colour = "Black"
        jaws.context.fillStyle = colour
        jaws.context.fillText(text, jaws.width / 2, (200 + 100))

        canDrawText = true
        setTimeout(->
            canDrawText = false
            return
        , 500)
        return
    return @


    
jaws.onload = ->
    parent.letsgo = true
    jaws.assets.add imgDir + "/face.png"
    jaws.assets.add imgDir + "/candle-lit.png"
    jaws.assets.add imgDir + "/candle-unlit.png"
    jaws.assets.add imgDir + "/breath.png"
    jaws.preventDefaultKeys ["space", "left", "right", "up", "down"]
    jaws.start(CandleBlower)
    return
