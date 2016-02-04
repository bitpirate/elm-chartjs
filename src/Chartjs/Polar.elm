module Chartjs.Polar
  ( chart, chart'
  , Options, defaultOptions
  , Series, Config
  , Style, defStyle, defaultStyle
  ) where

{-| API wrapper for Chartjs Polar charts

# Configure
@docs Config, Series

# Render
@docs chart, chart'

# Options
@docs Options, defaultOptions

# Style
@docs Style, defStyle, defaultStyle
-}

import Color exposing (white, rgba, rgb, Color)
import Chartjs exposing (..)
import Graphics.Element exposing (Element)

{-| Options for the Polar Chart
[Chartjs Docs](http://www.chartjs.org/docs/#polar-area-chart-chart-options).
In most cases just use `defaultOptions`
-}
type alias Options =
  { scaleShowLabelBackdrop : Bool
  , scaleBackdropColor : Color
  , scaleBeginAtZero : Bool
  , scaleBackdropPaddingY : Float
  , scaleBackdropPaddingX : Float
  , scaleShowLine : Bool
  , segmentShowStroke : Bool
  , segmentStrokeColor : Color
  , segmentStrokeWidth : Float
  , animationSteps : Int
  , animationEasing : String
  , animateRotate : Bool
  , animateScale : Bool
  , legendTemplate : String }

type alias OptionsRaw =
  { scaleShowLabelBackdrop : Bool
  , scaleBackdropColor : String
  , scaleBeginAtZero : Bool
  , scaleBackdropPaddingY : Float
  , scaleBackdropPaddingX : Float
  , scaleShowLine : Bool
  , segmentShowStroke : Bool
  , segmentStrokeColor : String
  , segmentStrokeWidth : Float
  , animationSteps : Int
  , animationEasing : String
  , animateRotate : Bool
  , animateScale : Bool
  , legendTemplate : String }

decodeOptions : Options -> OptionsRaw
decodeOptions o =
  { o | scaleBackdropColor = showRGBA o.scaleBackdropColor
      , segmentStrokeColor = showRGBA o.segmentStrokeColor }

{-| Codification of the default options [Chartjs Docs](http://www.chartjs.org/docs/#polar-area-chart-chart-options)

    chart 200 200 config defaultOptions

Pass just one option

    chart 200 200 config
      { defaultOptions | scaleBeginAtZero = False }

-}
defaultOptions : Options
defaultOptions =
  { scaleShowLabelBackdrop = True
  , scaleBackdropColor = rgba 255 255 255 0.75
  , scaleBeginAtZero = True
  , scaleBackdropPaddingY = 2.0
  , scaleBackdropPaddingX = 2.0
  , scaleShowLine = True
  , segmentShowStroke = True
  , segmentStrokeColor = white
  , segmentStrokeWidth = 2.0
  , animationSteps = 100
  , animationEasing = "easeOutBounce"
  , animateRotate = True
  , animateScale = False
  , legendTemplate = "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<segments.length; i++){%><li><span style=\"background-color:<%=segments[i].fillColor%>\"></span><%if(segments[i].label){%><%=segments[i].label%><%}%></li><%}%></ul>" }


{-| Style for a data points on the chart
[Chartjs Docs](http://www.chartjs.org/docs/#polar-area-chart-data-structure)
-}
type alias Style =
  { color: Color
  , highlight: Color }

{-| A default style for points, a light grey affair -}
defaultStyle : Style
defaultStyle =
  { color = rgb 148 159 177
  , highlight = rgb 168 179 197 }

{-| Convience function for making styles based on
a single color.

    myStyle = defStyle (RGBA 45 45 45)

-}
defStyle : (Float -> Color) -> Style
defStyle f =
  { color = f 1.0
  , highlight = f 0.9 }

{-| A Series to plot.
[Chartjs Docs](http://www.chartjs.org/docs/#polar-area-chart-data-structure) -}
type alias Series = (Label, Style, Float)

{-| Complete data model needed for rendering
Chartjs referrs to this as simply `data` in their docs -}
type alias Config = List Series

type alias ConfigRaw =
  JSArray { label : String
          , color : String
          , highlight : String
          , value : Float }

decodeConfig : Config -> ConfigRaw
decodeConfig series = let
  decode (label, style, d) =
    { label = label
    , color = showRGBA style.color
    , highlight = showRGBA style.highlight
    , value = d }
  in toArray (List.map decode series)

{-| Create a Chartjs Polar Chart in an Element

    chart height width myConfig defaultOptions

-}
chart : Int -> Int -> Config -> Options -> Element
chart w h c o = chartRaw "PolarArea" w h (decodeConfig c) (decodeOptions o)

{-| Same as `chart` but default options are assumed -}
chart' : Int -> Int -> Config -> Element
chart' w h c = chart w h c defaultOptions
