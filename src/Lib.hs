{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( playGTK
    ) where

import           Data.GI.Base
import qualified GI.Gtk         as Gtk
import GI.Gtk.Objects.Box (boxNew, boxPackStart, setBoxHomogeneous)
import GI.Gtk.Objects.Container (containerAdd)
import GI.Gtk.Enums (Orientation (..), WindowType(..))
import GI.Gtk.Objects.Widget (setWidgetHeightRequest, setWidgetWidthRequest)
import GI.Gtk.Objects.TextTag
import GI.Gtk.Objects.TextView
import GI.Gtk.Objects.TextBuffer
import qualified Data.Text      as T
import qualified Data.Text.IO   as TIO
import Data.Maybe
import MenuBar

playGTK :: IO ()
playGTK = do
    Gtk.init Nothing
    win <- new Gtk.Window [ #title := "棚ぼた!" ]
    Gtk.windowResize win 400 270
    on win #destroy Gtk.mainQuit
    setWidgetWidthRequest win 200
    setWidgetHeightRequest win 100
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

    tag <- asmTag
    -- textBufferApplyTag buffer tag iter iter

    setBoxHomogeneous hBox False
    boxPackStart hBox edit1 False False 0
    boxPackStart hBox edit2 False False 0

    setBoxHomogeneous vBox False
    boxPackStart vBox menu False False 0
    boxPackStart vBox button False False 0
    boxPackStart vBox hBox False False 0

    containerAdd win vBox

asmTag :: IO Gtk.TextTag
asmTag = do
    asm <- textTagNew (Just "asm")
    -- set asm #foregroundRgba (get Gtk.rGBA #red)
    setTextTagForeground asm "green"
    setTextTagBackground asm "black"
    return asm


sampleButton :: IO Gtk.Button
sampleButton = do
    btn <- new Gtk.Button [#label := "ここをクリック"]
    on btn #clicked $ set btn [ #sensitive := False,
                                   #label := "O.K." ]
    return btn

editor :: IO Gtk.TextView
editor = do
    tag <- asmTag
    buf <- textBufferNew (Nothing :: Maybe Gtk.TextTagTable)
    ed <- new Gtk.TextView [#leftMargin := 10]
    buf <- textViewGetBuffer ed
    set buf [#text := "asm123"]
    
    #setEditable ed False
    st <- #getIterAtOffset buf 0
    end <- #getIterAtOffset buf 10
    asm <- textTagNew (Just "asm")
    -- set asm #foregroundRgba (get Gtk.rGBA #red)
    setTextTagForeground asm "green"
    setTextTagBackground asm "black"
    textBufferApplyTag buf asm st end

    -- define the textBuffer-callback
    textBufferSetModified buf True
    on buf #changed $ textBufferChanged buf
    return ed

textBufferChanged :: Gtk.TextBuffer -> TextBufferModifiedChangedCallback -- == IO ()
textBufferChanged buf = do
    tag <- asmTag
    st <- #getIterAtOffset buf 0
    end <- #getIterAtOffset buf 10
    str <- #getText buf st end True
    TIO.putStrLn str
    textBufferApplyTag buf tag st end