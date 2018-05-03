module Main exposing (..)

import Html exposing (..)


segmentsCompare : List ( String, String ) -> Bool
segmentsCompare l =
    case List.head l of
        Just ( val, ref ) ->
            if val == ref || ref == "*" then
                case List.tail l of
                    Just next ->
                        segmentsCompare next

                    Nothing ->
                        True
            else
                False

        Nothing ->
            True


pathSegments : String -> List String
pathSegments s =
    String.split "/" s


pathsMatch : String -> String -> Bool
pathsMatch val ref =
    let
        ( v, r ) =
            ( pathSegments val, pathSegments ref )
    in
        if List.length v == List.length r then
            segmentsCompare <| List.map2 (,) v r
        else
            False


type alias PathsMatchTest =
    { name : String
    , val : String
    , ref : String
    , want : Bool
    }


pathsMatchTestResult : PathsMatchTest -> String
pathsMatchTestResult d =
    if pathsMatch d.val d.ref == d.want then
        ""
    else
        d.name
            ++ ": got "
            ++ (toString <| not d.want)
            ++ ", want "
            ++ toString d.want
            ++ "\n"


pathsMatchTestsResult : String
pathsMatchTestsResult =
    List.map pathsMatchTestResult
        [ PathsMatchTest "static inequal short" "oops/" "INBOX/test" False
        , PathsMatchTest "static inequal" "INBOX/oops" "INBOX/test" False
        , PathsMatchTest "static inequal long" "INBOX/testx" "INBOX/test" False
        , PathsMatchTest "static equal" "INBOX/test" "INBOX/test" True
        , PathsMatchTest "wildcard nonequiv prefix" "INBUZ/oops" "INBOX/*" False
        , PathsMatchTest "wildcard nonequiv long" "INBOX/something/test" "INBOX/*" False
        , PathsMatchTest "wildcard equiv" "INBOX/test" "INBOX/*" True
        , PathsMatchTest "wildcard equiv long" "INBOX/something/test" "INBOX/*/test" True
        ]
        |> List.filter (\r -> r /= "")
        |> String.concat


main : Html msg
main =
    pre [] [ text pathsMatchTestsResult ]
