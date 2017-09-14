module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


-- Request URL:
-- https://hipstore.now.sh/api/products


type alias Model =
    { products : List Product
    , error : String
    }


type alias Product =
    { description : String
    , photo : String
    , id : String
    }


type Msg
    = LoadProducts


main : Program Never Model Msg
main =
    program
        { init = init
        , subscriptions = \_ -> Sub.none
        , update = update
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    { products = []
    , error = ""
    }
        ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadProducts ->
            model
                ! []


view : Model -> Html Msg
view model =
    viewWrapper <|
        div []
            [ button [ onClick LoadProducts ] [ text "Load Hipster Stuff" ]
            , div []
                [ p [] [ text "You're just one click away from some fun hipster stuff." ] ]
            , p [ style [ ( "color", "red" ) ] ] [ text model.error ]
            ]


viewWrapper : Html msg -> Html msg
viewWrapper content =
    div [ style [ ( "padding", "2em" ), ( "max-width", "350px" ), ( "margin", "0 auto" ) ] ] [ content ]


productView : Product -> Html Msg
productView product =
    div []
        [ h1 [] [ text product.description ]
        , img [ src ("https://hipstore.now.sh/" ++ product.photo), style [ ( "max-width", "100%" ) ] ] []
        ]
