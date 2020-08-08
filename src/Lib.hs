{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( playGTK
    ) where

import           Data.GI.Base
import qualified GI.Gtk       as Gtk
import GI.Gtk.Objects.Box (boxNew, boxPackStart, setBoxHomogeneous)
import GI.Gtk.Objects.Container (containerAdd)
import GI.Gtk.Enums (Orientation (..), WindowType(..))
import MenuBar

playGTK :: IO ()
playGTK = do
    Gtk.init Nothing
    win <- new Gtk.Window [ #title := "棚ぼた!" ]
    Gtk.windowResize win 400 270
    on win #destroy Gtk.mainQuit
    setWidgets win
    #showAll win
    Gtk.main

setWidgets win = do
    menu <- menubar
    edit1 <- editor
    edit2 <- editor
    button <- sampleButton
    hBox <- boxNew OrientationHorizontal 0
    vBox <- boxNew OrientationVertical 0

    setBoxHomogeneous hBox False
    boxPackStart hBox edit1 False False 0
    boxPackStart hBox edit2 False False 0

    setBoxHomogeneous vBox False
    boxPackStart vBox menu False False 0
    boxPackStart vBox button False False 0
    boxPackStart vBox hBox False False 0

    containerAdd win vBox


sampleButton :: IO Gtk.Button
sampleButton = do
    btn <- new Gtk.Button [#label := "ここをクリック"]
    on btn #clicked $ set btn [ #sensitive := False,
                                   #label := "O.K." ]
    return btn

editor :: IO Gtk.TextView
editor = do
    ed <- new Gtk.TextView [#leftMargin := 10]
    return ed