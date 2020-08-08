# gtkplayroom

エディタを作るためのツールとして，GI_GTKに慣れることが目的．

### 依存関係
```
dependencies:
- base >= 4.7 && < 5
- gi-gtk
- haskell-gi-base
- text
```

下記コマンドを実行しGTKをinstall(手元では2回実行することで正しくリンク作業が完了した)
```
brew install gobject-introspection gtk+ gtk+3
```
