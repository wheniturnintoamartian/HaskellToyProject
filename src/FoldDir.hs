module FoldDir where

import ControlledVisit
import System.FilePath ((</>), takeExtension, takeFileName)
import Data.Char (toLower)
import Data.List.Split

data Iterate seed = Done { unwrap :: seed }
                  | Skip { unwrap :: seed }
                  | Continue { unwrap :: seed }
                    deriving (Show)

type Iterator seed = seed -> Info -> Iterate seed

foldTree :: Iterator a -> a -> FilePath -> IO a
foldTree iter initSeed path = do
        endSeed <- fold initSeed path
        return (unwrap endSeed)
    where
        fold seed subpath = getUsefulContents subpath >>= walk seed
        walk seed (name:names) = do
            let path' = path </> name
            putStrLn path'
            info <- getInfo path'
            case iter seed info of
                 done@(Done _) -> return done
                 Skip seed' -> walk seed' names
                 Continue seed'
                    | isDirectory info -> do
                        next <- fold seed' path'
                        case next of
                             done@(Done _) -> return done
                             seed'' -> walk (unwrap seed'') names
                    | otherwise -> walk seed' names
        walk seed _ = return (Continue seed)

foldTree' :: Iterator a -> a -> FilePath -> IO a
foldTree' iter initSeed path = fold iter initSeed path path >>= return . unwrap

fold :: Iterator a -> a -> FilePath -> FilePath -> IO (Iterate a)
fold iter seed subpath path = getUsefulContents subpath >>= walk iter seed path
        
walk :: Iterator a -> a -> FilePath -> [String] -> IO (Iterate a)
walk iter seed path (name:names) = do
            let path' = path </> name
            putStrLn path'
            info <- getInfo path'
            case iter seed info of
                done@(Done _) -> return done
                Skip seed' -> walk iter seed' path names
                Continue seed'
                    | isDirectory info -> do
                        next <- fold iter seed' path' path'
                        case next of
                            done@(Done _) -> return done
                            seed'' -> walk iter (unwrap seed'') path names
                    | otherwise -> walk iter seed' path names
walk _ seed _ [] = return (Continue seed)

atMostThreePictures :: Iterator [FilePath]
atMostThreePictures paths info
        | length paths == 3
            = Done paths
        | isDirectory info && (lastDirectory == ".svn" || lastDirectory == ".git")
            = Skip paths
        | extension `elem` [".jpg", ".png"]
            = Continue (path : paths)
        | otherwise
            = Continue paths
    where extension = map toLower (takeExtension path)
          path = infoPath info
          lastDirectory = last $ splitOn "/" path

countDirectories :: Iterator Int
countDirectories count info =
    Continue (if isDirectory info
                 then count + 1
                 else count)