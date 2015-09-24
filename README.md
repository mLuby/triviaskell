# triviaskell
Simple trivia server in Haskell

###Setup

0. install Haskell: `$ brew install ghc cabal-install`
0. clone the repo `$ git clone git@github.com:mLuby/triviaskell.git && cd triviaskell`
0. use cabal to install dependencies `$ cabal update && cabal install`
0. compile and run the server `$ ghc -o server.executable server.hs && ./server.executable`

or all at once:  

```bash
brew install ghc cabal-install
git clone git@github.com:mLuby/triviaskell.git && cd triviaskell
cabal update && cabal install
ghc -o server.executable server.hs && ./server.executable
```

#Newer instructions:

0. install stack.
0. in repo, run `$ stack build && stack exec trivia`.
0. `$ curl localhost:3000/questions/1`
0. `$ curl localhost:3000/questions/`
