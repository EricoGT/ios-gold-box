# Walmart App iOS
Aplicativo nativo do Walmart.com para o iOS.

## Libraries
- FXKeychain
- CardIO
- Facebook
- DateTools
- Flurry
- HockeyApp
- JsonModel
- Omniture
- Urban Airship

## Walmart App iOS
```sh
cd ~/Documents
git clone -b develop https://gitlab.wmxp.com.br/mobile/walmart-app-ios.git
```

## Dependência
#### CardIO
```sh
cd ~/Documents
git clone https://gitlab.wmxp.com.br/mobile/walmart-app-ios-cardio.git
cp -rf walmart-app-ios-cardio/*.a walmart-app-ios/Libraries/CardIO
```

#### JSON Mocks (gitsubmodule)
```sh
cd ~/Documents/walmart-app-ios
git submodule update --init --recursive
git submodule update --remote
```

## Iniciar Projeto
```sh
cd ~/Documents/walmart-app-ios && open Walmart.xcodeproj
```
