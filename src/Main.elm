module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Request)
import Json.Decode
import Json.Decode.Pipeline


-- Request URL:
-- https://hipstore.now.sh/api/products


productsRequest : Request (List Product)
productsRequest =
    Http.get "https://hipstore.now.sh/api/products" (Json.Decode.list productDecoder)


productDecoder : Json.Decode.Decoder Product
productDecoder =
    Json.Decode.Pipeline.decode Product
        -- description -> name
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        -- photo -> image
        |> Json.Decode.Pipeline.required "image" Json.Decode.string
        -- id -> id
        |> Json.Decode.Pipeline.required "id" Json.Decode.string


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
    | GotProducts (List Product)
    | ShowError String


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
        ShowError err ->
            { model | error = err } ! []

        GotProducts products ->
            { model | products = products } ! []

        LoadProducts ->
            model
                ! [ Http.send
                        (\res ->
                            case res of
                                Ok products ->
                                    GotProducts products

                                Err httpErr ->
                                    ShowError (toString httpErr)
                        )
                        productsRequest
                  ]


view : Model -> Html Msg
view model =
    viewWrapper <|
        div []
            [ button [ onClick LoadProducts ] [ text "Load Hipster Stuff" ]
            , div []
                [ if List.length model.products > 0 then
                    div [] (List.map productView model.products)
                  else
                    p [] [ text "You're just one click away from some fun hipster stuff." ]
                ]
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
