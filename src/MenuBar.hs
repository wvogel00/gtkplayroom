{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}

module MenuBar where

import Data.Text (Text)
import qualified Data.Text.IO as TIO (readFile)
import qualified GI.Gtk.Functions as GI (main, init)
import GI.Gtk.Objects.Action (onActionActivate, actionNew)
import GI.Gtk.Functions (mainQuit)
import GI.Gtk.Objects.ActionGroup
       (actionGroupAddActionWithAccel, actionGroupAddAction,
        actionGroupNew)
import GI.Gtk.Objects.UIManager
       (uIManagerGetWidget, uIManagerInsertActionGroup,
        uIManagerAddUiFromString, uIManagerNew)
import GI.Gtk.Objects.Window (windowNew)
import GI.Gtk.Objects.Widget
       (widgetShowAll, setWidgetHeightRequest, setWidgetWidthRequest,
        onWidgetDestroy)
import GI.Gtk.Objects.TextView (textViewNew)
import GI.Gtk.Objects.Box (boxNew, boxPackStart, setBoxHomogeneous)
import GI.Gtk.Objects.Container (containerAdd)
import GI.Gtk.Enums (Orientation (..), WindowType(..))
import qualified Data.Text as T (length)

menubar = do
  fileAct <- actionNew "FileAction" (Just "File") Nothing Nothing
  editAct <- actionNew "EditAction" (Just "Edit") Nothing Nothing

  -- Create menu items
  newAct <- actionNew "NewAction" (Just "New")
            (Just "Clear the spreadsheet area.")
            (Just "_New")
  onActionActivate newAct $ putStrLn "New activated."
  openAct <- actionNew "OpenAction" (Just "Open")
            (Just "Open an existing spreadsheet.")
            (Just "_Open")
  onActionActivate openAct $ putStrLn "Open activated."
  saveAct <- actionNew "SaveAction" (Just "Save")
            (Just "Save the current spreadsheet.")
            (Just "_Save")
  onActionActivate saveAct $ putStrLn "Save activated."

  saveAsAct <- actionNew "SaveAsAction" (Just "SaveAs")
            (Just "Save spreadsheet under new name.")
            (Just "Save_As")
  onActionActivate saveAsAct $ putStrLn "SaveAs activated."
  
  exitAct <- actionNew "ExitAction" (Just "Exit")
            (Just "Exit this application.")
            (Just "_Quit")
  onActionActivate exitAct mainQuit
  
  cutAct <- actionNew "CutAction" (Just "Cut")
            (Just "Cut out the current selection.")
            (Just "Cu_t")
  onActionActivate cutAct $ putStrLn "Cut activated."
  copyAct <- actionNew "CopyAction" (Just "Copy")
            (Just "Copy the current selection.")
            (Just "_Copy")
  onActionActivate copyAct $ putStrLn "Copy activated."
  pasteAct <- actionNew "PasteAction" (Just "Paste")
            (Just "Paste the current selection.")
            (Just "_Paste")
  onActionActivate pasteAct $ putStrLn "Paste activated."

  standardGroup <- actionGroupNew ("standard"::Text)
  mapM_ (actionGroupAddAction standardGroup) [fileAct, editAct]
  mapM_ (\act -> actionGroupAddActionWithAccel standardGroup act (Nothing::Maybe Text))
    [newAct, openAct, saveAct, saveAsAct, exitAct, cutAct, copyAct, pasteAct]

  ui <- uIManagerNew
  menustyle <- TIO.readFile "style/menu.style"
  mid <- uIManagerAddUiFromString ui menustyle (fromIntegral $ T.length menustyle)
  uIManagerInsertActionGroup ui standardGroup 0

  Just menuBar <- uIManagerGetWidget ui "/ui/menubar"
  -- Just toolBar <- uIManagerGetWidget ui "/ui/toolbar"

  return menuBar