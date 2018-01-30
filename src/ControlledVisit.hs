{-# LANGUAGE ScopedTypeVariables #-}

module ControlledVisit where

import System.Directory (Permissions(..), getModificationTime, getPermissions, getDirectoryContents)
import Data.Time.Clock (UTCTime(..))
import Control.Exception (bracket, handle, Exception, IOException)
import System.IO (IOMode(..), hClose, hFileSize, openFile)
import System.FilePath ((</>))
import Control.Monad (forM, liftM)

data Info = Info {
      infoPath :: FilePath
    , infoPerms :: Maybe Permissions
    , infoSize :: Maybe Integer
    , infoModTime :: Maybe UTCTime
} deriving (Eq, Ord, Show)

getInfo :: FilePath -> IO Info
getInfo path = do
    perms <- maybeIO (getPermissions path)
    size <- maybeIO (bracket (openFile path ReadMode) hClose hFileSize)
    modified <- maybeIO (getModificationTime path)
    return (Info path perms size modified)

traverseFun :: ([Info] -> [Info]) -> FilePath -> IO [Info]
traverseFun order path = do
    names <- getUsefulContents path
    contents <- mapM getInfo (path : map (path </>) names)
    liftM concat $ forM (order contents) $ \info -> do
        if isDirectory info && infoPath info /= path
            then traverseFun order (infoPath info)
            else return [info]

getUsefulContents :: FilePath -> IO [String]
getUsefulContents path = do
    names <- getDirectoryContents path
    return (filter (`notElem` [".", ".."]) names)
    
isDirectory :: Info -> Bool
isDirectory = maybe False searchable . infoPerms

maybeIO :: IO a -> IO (Maybe a)
maybeIO act = handle (\(_ :: IOException) -> return Nothing) (Just `liftM` act)
