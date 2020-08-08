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

## 実行画面の例
![image](https://user-images.githubusercontent.com/991030/89706263-f6638980-d99e-11ea-806a-f360fb03f786.png)