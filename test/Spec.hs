import SimpleJSON
import PutJSON

main :: IO ()
main = do putStrLn ""
          putJValue $ JBool True
          putJValue $ JBool False
          putJValue JNull
          putJValue $ JString "kurwa"
          putJValue $ JNumber 3
          putJValue $ JNumber 34.33
          putJValue $ JObject [("asdf", JString "fadf"), 
                               ("fadf", JBool True), 
                               ("fjalfwe", JBool False),
                               ("r3r2", JNull),
                               ("r23r2", JNumber 4342),
                               ("fasdf", JObject [("fadf", JNumber 3)]),
                               ("fasd3f", JArray [JNumber 3])]
          putJValue $ JArray [JNull]
